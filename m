Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6965F53A7;
	Fri,  6 Dec 2024 15:16:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733498204; cv=none; b=O08qTldW9OK8Bj5ZXvFwisRFdJav0Sn6jRSPIYMTZTzZZ/XsAZBVlSKmOzhz6AZLMWhp7WN+3Msz9/g7t4RF5DuV+iIJOWcFROtoTSIk5d5WAK1RNnJBmzmKmBR7a4pCFYUwsfn+oNlEBuOGIVPB5yEsfua0lWlS4lnei/7306o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733498204; c=relaxed/simple;
	bh=Fs3mLOHKD+i6ZX4PHoLgLAmRGFfiTa623BSrOpWI8R0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eW7uf4P0nqFCd/6e9XV5ZL8DImjPZd89wreYZz7mTxhoA5ScO3mU2UeTMWejhiRc6l6WT7aQjXkoRanX6g5PjaAJ6grVofCVE1BEk4VW0DeWdOUi2XP7svXrte44dl6v0SsgWYVFVpgbO7NSsYVW0idhOzNo7spgE8Lzm78/1J4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rio2Xi3V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rio2Xi3V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC9B8C4CED1;
	Fri,  6 Dec 2024 15:16:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733498204;
	bh=Fs3mLOHKD+i6ZX4PHoLgLAmRGFfiTa623BSrOpWI8R0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rio2Xi3VJcmT2pgAQeKnmjOu2WckGnHpZEnO6bH0OhpII4KXJnCZgOuKEHHfxR+9t
	 fsiF3Swj2QrWmzcXnFigCuwNiuHxWJGmkGSN/7MwyX9zQqnD3nVpbnvkCp6OFcXC69
	 Pk0ExWN+wQrL+xh803h1h6uZIMM9h+jS4gVnuRBc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Tzung-Bi Shih <tzungbi@kernel.org>
Subject: [PATCH 6.6 514/676] platform/chrome: cros_ec_typec: fix missing fwnode reference decrement
Date: Fri,  6 Dec 2024 15:35:33 +0100
Message-ID: <20241206143713.439982719@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

From: Javier Carrasco <javier.carrasco.cruz@gmail.com>

commit 9c41f371457bd9a24874e3c7934d9745e87fbc58 upstream.

The device_for_each_child_node() macro requires explicit calls to
fwnode_handle_put() upon early exits (return, break, goto) to decrement
the fwnode's refcount, and avoid levaing a node reference behind.

Add the missing fwnode_handle_put() after the common label for all error
paths.

Cc: stable@vger.kernel.org
Fixes: fdc6b21e2444 ("platform/chrome: Add Type C connector class driver")
Signed-off-by: Javier Carrasco <javier.carrasco.cruz@gmail.com>
Link: https://lore.kernel.org/r/20241013-cross_ec_typec_fwnode_handle_put-v2-1-9182b2cd7767@gmail.com
Signed-off-by: Tzung-Bi Shih <tzungbi@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/chrome/cros_ec_typec.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/platform/chrome/cros_ec_typec.c
+++ b/drivers/platform/chrome/cros_ec_typec.c
@@ -390,6 +390,7 @@ static int cros_typec_init_ports(struct
 	return 0;
 
 unregister_ports:
+	fwnode_handle_put(fwnode);
 	cros_unregister_ports(typec);
 	return ret;
 }


