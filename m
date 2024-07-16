Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 009021DDE9;
	Tue, 16 Jul 2024 16:02:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145773; cv=none; b=SGAHhZFaWdQgbghn7h4PqdEytkTNEBLmS9EEjhkJ2noplJwfjDdbllcQ+89avPVaXRDrzKFN/FtnVmKlVU0g82UP3BbjiMxuzpI3mY6NDEETTKxH7ePY05dLnx8zwJbBaB2gS1oC/BUoO81GEMhq3ELEMVHnhvpRfliLARuaauc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145773; c=relaxed/simple;
	bh=vwywWj338hgXl3HXZqsoSJW6+SHGHpyOc2NaLTXnXmE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mW6qiiopPWtY62btQHS7PiUvha5cHP/xb2MSE8BAzKO1cuyFAq2JcLYqpmIc5/DPEt5aXP73M7RVYZvh4wS1sSWrJ56YkKwW1oZzKS1IEi0fkmaY2Mr1A88OBCCxJLcqlilp3KX38u0LtRaoI4/uMUAb0sFl0Tx0q+4lfhuK9Ag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j4FVWDZz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j4FVWDZz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B53EC116B1;
	Tue, 16 Jul 2024 16:02:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721145772;
	bh=vwywWj338hgXl3HXZqsoSJW6+SHGHpyOc2NaLTXnXmE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j4FVWDZz+Q7qMCbG729ixIMAosR+pDkeGIJVGQefI3rKI8x08ie6NROZVsRQvAIor
	 dXJ9Erue2ecpxwRiEMVLhNLdJHLNC/ZrUBu5oEycuuFhcEY9UJGIY2dDAPytiQMqk8
	 LCaf/kVg9pTVbolIIGDd4EDNuSLkJ44LUEDPzGMI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joy Chakraborty <joychakr@google.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH 6.6 079/121] nvmem: rmem: Fix return value of rmem_read()
Date: Tue, 16 Jul 2024 17:32:21 +0200
Message-ID: <20240716152754.368125640@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152751.312512071@linuxfoundation.org>
References: <20240716152751.312512071@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joy Chakraborty <joychakr@google.com>

commit 28b008751aa295612318a0fbb2f22dd4f6a83139 upstream.

reg_read() callback registered with nvmem core expects 0 on success and
a negative value on error but rmem_read() returns the number of bytes
read which is treated as an error at the nvmem core.

This does not break when rmem is accessed using sysfs via
bin_attr_nvmem_read()/write() but causes an error when accessed from
places like nvmem_access_with_keepouts(), etc.

Change to return 0 on success and error in case
memory_read_from_buffer() returns an error or -EIO if bytes read do not
match what was requested.

Fixes: 5a3fa75a4d9c ("nvmem: Add driver to expose reserved memory as nvmem")
Cc: stable@vger.kernel.org
Signed-off-by: Joy Chakraborty <joychakr@google.com>
Reviewed-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20240628113704.13742-2-srinivas.kandagatla@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvmem/rmem.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/nvmem/rmem.c
+++ b/drivers/nvmem/rmem.c
@@ -46,7 +46,10 @@ static int rmem_read(void *context, unsi
 
 	memunmap(addr);
 
-	return count;
+	if (count < 0)
+		return count;
+
+	return count == bytes ? 0 : -EIO;
 }
 
 static int rmem_probe(struct platform_device *pdev)


