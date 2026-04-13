Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22F6731354F;
	Mon, 13 Apr 2026 17:04:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776099842; cv=none; b=KtVGx41Zt+6HJCaJoNI9d3TeCztVZE9LuTJlYLti3MFLdyfCkkmUVwgdDb6ujF3Iss7PAhAQrtqsDuTyQbLU71lcfVfuK/LVZL5nkTb/jD00MpDY2Qfe/Z9paHg99jiJPbPML7oiou3WQGGptgwGjZVwiyGVc+5zf7Y/AaZxK+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776099842; c=relaxed/simple;
	bh=s3iO4BnXBdq21pt9BCuizcdZqR/DgYLsAMWOewM7x8U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t0Jt2lh0///2MjuaSiEXxhtHAC2cVd8QQmpbIq78ER0Q2Vnyekol01E0RBswQ780o3KBBJnPvTSwaJfHmX/YZIsehy5Pe1lNUlYCCoz3dkp4QDGfDEOl9VHWVzqza0S4xIh+Iratooc8Ujlt89nYOPgMKhFnDP2vd5kuGgNumQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z5K2TmgW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z5K2TmgW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACEABC2BCAF;
	Mon, 13 Apr 2026 17:04:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776099842;
	bh=s3iO4BnXBdq21pt9BCuizcdZqR/DgYLsAMWOewM7x8U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z5K2TmgWHHI14uid425C90asSHCxsJ+MdqOTN+0lh7DbjqURkzrzf9Yof7eITZJqJ
	 qlBcn+jqApwEDBm5ZNRM/sW2BQrpyKyQwM3Vt79n3H1APscZTS+kx4VvdLHh5COeWV
	 2T/ReHr6722QMwaFmFF8jPfuJG1JaWn0Hx72Qrsk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	GuoHan Zhao <zhaoguohan@kylinos.cn>,
	Juergen Gross <jgross@suse.com>
Subject: [PATCH 5.10 453/491] xen/privcmd: unregister xenstore notifier on module exit
Date: Mon, 13 Apr 2026 18:01:38 +0200
Message-ID: <20260413155835.995440150@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

From: GuoHan Zhao <zhaoguohan@kylinos.cn>

commit cd7e1fef5a1ca1c4fcd232211962ac2395601636 upstream.

Commit 453b8fb68f36 ("xen/privcmd: restrict usage in
unprivileged domU") added a xenstore notifier to defer setting the
restriction target until Xenstore is ready.

XEN_PRIVCMD can be built as a module, but privcmd_exit() leaves that
notifier behind. Balance the notifier lifecycle by unregistering it on
module exit.

This is harmless even if xenstore was already ready at registration
time and the notifier was never queued on the chain.

Fixes: 453b8fb68f3641fe ("xen/privcmd: restrict usage in unprivileged domU")
Signed-off-by: GuoHan Zhao <zhaoguohan@kylinos.cn>
Reviewed-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Message-ID: <20260325120246.252899-1-zhaoguohan@kylinos.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/xen/privcmd.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/xen/privcmd.c
+++ b/drivers/xen/privcmd.c
@@ -1069,6 +1069,9 @@ static int __init privcmd_init(void)
 
 static void __exit privcmd_exit(void)
 {
+	if (!xen_initial_domain())
+		unregister_xenstore_notifier(&xenstore_notifier);
+
 	misc_deregister(&privcmd_dev);
 	misc_deregister(&xen_privcmdbuf_dev);
 }


