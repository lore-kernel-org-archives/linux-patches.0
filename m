Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE06C3EB0F5;
	Tue, 16 Jun 2026 18:57:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781636279; cv=none; b=UGPIwerFNT0TlZAB0vd5lyCNFhZK6KCcXeolFZH/uaDics2HnilMMuVLdHzso3SX+YAhyF6ARKCM+fCzaK7jetF58TVXlVrJbsUpmYVbAWt/40PgytuMXSy3uJdjIIiMYYh4s6gsCUb064oqpTDAtj4RGqNspxbijqRCiXNaPew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781636279; c=relaxed/simple;
	bh=cryNtjNjdsdtVVlMbPmweJJRkosRPPDfI5Di+zll9iY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VsSET/Fv9Iva/7ZFZD7lQEXhDDYUlkGpstNmUC7nrG0zpu/P5lOPdVdBXaJ2hdLsOGmNsrZQGezSN795Oz8St4iS+4DV5K8egrXuLajZcTXGkC9IyaSghqKvluTJQnanvwLvCP4SblSwG7O1AljdoRRnFQULq7/b0Zjbs1q/Owo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fySXhsF6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fySXhsF6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5F661F000E9;
	Tue, 16 Jun 2026 18:57:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781636278;
	bh=geLTNC6+lccH/tCdT0Sypmtw5OB8NIA9qXnb4Sv9QSs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fySXhsF6acbqGHNT7PjgeKq0VmPUqEus90q/OFGphrELlcwYt1t09i/9S+A0VtE0V
	 9SRmhozNsrEOEYK1pZvlSKYmZg+fRx51pRxeG2zS5jMdpO1cVhmK4TaEorUt0aK3tx
	 pKlnDj2+ilNRtA2JLtX7iQnrOoAXj7A8o6LCwFA8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 5.10 208/342] thunderbolt: Bound root directory content to block size
Date: Tue, 16 Jun 2026 20:28:24 +0530
Message-ID: <20260616145057.869703120@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145048.348037099@linuxfoundation.org>
References: <20260616145048.348037099@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Bommarito <michael.bommarito@gmail.com>

commit 65423079c7420e3dbf9a7aa345c243a3f5752e5d upstream.

__tb_property_parse_dir() does not check that content_offset +
content_len fits within block_len for the root directory case.
When rootdir->length equals or exceeds block_len - 2, the entry
loop reads past the allocated property block.

Add a bounds check after computing content_offset and content_len
to reject directories whose content extends past the block.

Fixes: cdae7c07e3e3 ("thunderbolt: Add support for XDomain properties")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-7
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thunderbolt/property.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/thunderbolt/property.c
+++ b/drivers/thunderbolt/property.c
@@ -181,6 +181,10 @@ static struct tb_property_dir *__tb_prop
 	if (is_root) {
 		content_offset = dir_offset + 2;
 		content_len = dir_len;
+		if (content_offset + content_len > block_len) {
+			tb_property_free_dir(dir);
+			return NULL;
+		}
 	} else {
 		if (dir_len < 4) {
 			tb_property_free_dir(dir);


