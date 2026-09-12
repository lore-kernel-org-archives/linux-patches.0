Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C8632D0C75;
	Sat, 12 Sep 2026 11:40:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789213241; cv=none; b=U0ykjYyR+mOotHVBD/w4aBAnOhRXBNnDLs76bCaoNz5BSYS+kEPYSgOoi7iLU6kW+Mk8NTZoE4CnYjcBg2AzzYyTaJ1dJqyQ2nJtNqnKfMVDH8hFueojLpIs9nSErM10BY3t6nqKXlkq8nhO5KHHeaVDBplNvT4+477re5zcHCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789213241; c=relaxed/simple;
	bh=h9CGirHo/alTqEV8RyfatgSuJ3WArGxcZiaC+m5ZCsI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TsWm4YS2iliOELTpagYGZiX7U1hjKbFjCWWyTa9J0A0y/Oad3u8NURX/5oAaK66LvRujtuQSf6M0R52Xy6OrFv6MZwWOb6yy6orQRmxL6p0fGE6f2GTM4wfyN2HyINzN0bcTphoYs/nMjpd5JWURUE7uPmDz6hwKZ2Moz580Fzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jZ1yONvj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jZ1yONvj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 247AF1F000FF;
	Sat, 12 Sep 2026 11:40:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789213240;
	bh=RM7pBYMpuuqCk2Lz4F/pVhG56aoI5doovXiXh0I2LYk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jZ1yONvj/WSeRFzVu8ar9coVe7Re3JuTzkukCNcsfy9soABwL27oxGiWTYJLqR1xO
	 Vjran4HGATQpDCKff5ZZrKcQDSjAghN3i0BmYpIH9LRN6HZPPNRmKwsuv9GJLnhSwU
	 fp2eGkL6fHoavADKI29LsAfmod8w8nHqcOani6fU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ahmad Byagowi <ahmadexp@gmail.com>,
	Peter Rosin <peda@lysator.liu.se>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 6.12 0080/1376] i2c: mux: Fix channel node leak on adapter add failure
Date: Sat, 12 Sep 2026 08:41:46 +0200
Message-ID: <20260912065609.342988742@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ahmad Byagowi <ahmadexp@gmail.com>

commit 385c7af4e3b95d0769fd211831674e83b16a2ebf upstream.

i2c_mux_add_adapter() takes a reference to the Device Tree channel node
before registering the new adapter. If adapter registration fails, the
error path frees the private data without dropping that reference.

Release the channel node before freeing the private data.

Fixes: bc45449b1444 ("i2c/of: Automatically populate i2c mux busses from device tree data.")
Signed-off-by: Ahmad Byagowi <ahmadexp@gmail.com>
Cc: <stable@vger.kernel.org> # v3.5+
Acked-by: Peter Rosin <peda@lysator.liu.se>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Link: https://patch.msgid.link/b3e46bbee781b3cb4029aca9a71316cc5e36dc17.1787502619.git.ahmadexp@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/i2c-mux.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/i2c/i2c-mux.c
+++ b/drivers/i2c/i2c-mux.c
@@ -411,6 +411,7 @@ int i2c_mux_add_adapter(struct i2c_mux_c
 	return 0;
 
 err_free_priv:
+	of_node_put(priv->adap.dev.of_node);
 	kfree(priv);
 	return ret;
 }


