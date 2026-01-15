Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 561CA345758;
	Thu, 15 Jan 2026 17:04:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496657; cv=none; b=S/aq/mFcnQ0eMO+P6AuMRc0TJlZRXmmjkrQzgemHDDV/tGH7peeLhALZDaYz68TNLuK9yGqY/nb5gcQXz7Z0FV8qouKIDOn+6s6gcnC3RXxjTj6z/9ZABmie/AYvHG5uBxubZVQWW9b1P8RxrxFBlziyrJtjI8IbZfz+lNFLMwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496657; c=relaxed/simple;
	bh=qc288gK2jV1W+WO8hE4Yv8cIyqhnvEwyfeKphrBFyxc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nbpc0kPjQ/aQBXVQJWH/UFqaDE58VFCxu4LkQQPv9JDJ6LvAHDg3dDriXQtIaeVQIC0sEcgHZykK4mxsJCGZtNxRtMtd/PluYoBSF56XSUwYtmVCSMzXnaFZjUAFe8zm3zP0MntJMzdrYmW8RAQeKRrDYZMUVLliE6enO6SApM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mxhlEgZ/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mxhlEgZ/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FA77C19422;
	Thu, 15 Jan 2026 17:04:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496656;
	bh=qc288gK2jV1W+WO8hE4Yv8cIyqhnvEwyfeKphrBFyxc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mxhlEgZ/ulYwnqViKi6zUO02OHJunvy3Mc1H8dnOXuMZPRJibgGDzFgeefrtwMjJG
	 vyEwca/5pMOprRkdaugiyAMYI3b7WvRS8YDLrtfgZiLUn/W5LnSNWZsV6/pdJwP0Hb
	 0Zbuy6wX58k6rSHlA3dvKgdYDjpQ1mjGA7f0vd80=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 089/119] ALSA: ac97: fix a double free in snd_ac97_controller_register()
Date: Thu, 15 Jan 2026 17:48:24 +0100
Message-ID: <20260115164155.161642503@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164151.948839306@linuxfoundation.org>
References: <20260115164151.948839306@linuxfoundation.org>
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

From: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>

[ Upstream commit 830988b6cf197e6dcffdfe2008c5738e6c6c3c0f ]

If ac97_add_adapter() fails, put_device() is the correct way to drop
the device reference. kfree() is not required.
Add kfree() if idr_alloc() fails and in ac97_adapter_release() to do
the cleanup.

Found by code review.

Fixes: 74426fbff66e ("ALSA: ac97: add an ac97 bus")
Cc: stable@vger.kernel.org
Signed-off-by: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>
Link: https://patch.msgid.link/20251219162845.657525-1-lihaoxiang@isrc.iscas.ac.cn
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/ac97/bus.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/sound/ac97/bus.c
+++ b/sound/ac97/bus.c
@@ -298,6 +298,7 @@ static void ac97_adapter_release(struct
 	idr_remove(&ac97_adapter_idr, ac97_ctrl->nr);
 	dev_dbg(&ac97_ctrl->adap, "adapter unregistered by %s\n",
 		dev_name(ac97_ctrl->parent));
+	kfree(ac97_ctrl);
 }
 
 static const struct device_type ac97_adapter_type = {
@@ -319,7 +320,9 @@ static int ac97_add_adapter(struct ac97_
 		ret = device_register(&ac97_ctrl->adap);
 		if (ret)
 			put_device(&ac97_ctrl->adap);
-	}
+	} else
+		kfree(ac97_ctrl);
+
 	if (!ret) {
 		list_add(&ac97_ctrl->controllers, &ac97_controllers);
 		dev_dbg(&ac97_ctrl->adap, "adapter registered by %s\n",
@@ -360,14 +363,11 @@ struct ac97_controller *snd_ac97_control
 	ret = ac97_add_adapter(ac97_ctrl);
 
 	if (ret)
-		goto err;
+		return ERR_PTR(ret);
 	ac97_bus_reset(ac97_ctrl);
 	ac97_bus_scan(ac97_ctrl);
 
 	return ac97_ctrl;
-err:
-	kfree(ac97_ctrl);
-	return ERR_PTR(ret);
 }
 EXPORT_SYMBOL_GPL(snd_ac97_controller_register);
 


