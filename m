Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A8C621C9E5;
	Wed, 19 Mar 2025 14:38:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395130; cv=none; b=lZQeqnLTz/GGgjmGnsD0l4ga/3C/HuB9CY7GnYeLG2/XMWKZZIAXdakdA7yrQu08vfxkk102AyYFskwpOtvRpxx39bYeGRfnIO4B2FYN9JyA4VDjku/jf1BZXW7yu9SfuF+O31ibaaSuDVPim0qFjf16guycR0Z9OCJC8Q1GNsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395130; c=relaxed/simple;
	bh=ODFVkCoL2FzGrmJ1EqiUrw2ziPwbHLPjjSC0MsN4EHY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dDZICXn9bNQ20yfZ3QjaDEtlfJgfL+DVUgEl1PttUKfORI53svneTo3CijwKEDKAz1VwB8MQ1AAR40S8WeaiTBmBzUFsb7rTn1WehYCsig/oPev4edV9QySNq0CPF+PEaWKxd6+/kTM7CJH/LYODoak+Ixz+MYnWt2vTIJNQHRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hBZWtZXG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hBZWtZXG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB294C4CEE4;
	Wed, 19 Mar 2025 14:38:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395129;
	bh=ODFVkCoL2FzGrmJ1EqiUrw2ziPwbHLPjjSC0MsN4EHY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hBZWtZXGI0dUBTYl1501A4ROyLajnYRIUVMJjpFabIWept5Bz1d/j/pnRmquJqXhI
	 c6MOGCUl/dhnE2I551nizZZJtoj270pXyukZwIw3WasjUSsNo5FJW97iEmFssCi40X
	 MoSRssn3S4s6kDcP3kC8LqLvC3E3yhigv14rvyRM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adam Williamson <awilliam@redhat.com>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.12 194/231] smb: client: fix regression with guest option
Date: Wed, 19 Mar 2025 07:31:27 -0700
Message-ID: <20250319143031.633707200@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143026.865956961@linuxfoundation.org>
References: <20250319143026.865956961@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Paulo Alcantara <pc@manguebit.com>

commit fc99045effa81fdf509c2a97cbb7e6e8f2fd4443 upstream.

When mounting a CIFS share with 'guest' mount option, mount.cifs(8)
will set empty password= and password2= options.  Currently we only
handle empty strings from user= and password= options, so the mount
will fail with

	cifs: Bad value for 'password2'

Fix this by handling empty string from password2= option as well.

Link: https://bbs.archlinux.org/viewtopic.php?id=303927
Reported-by: Adam Williamson <awilliam@redhat.com>
Closes: https://lore.kernel.org/r/83c00b5fea81c07f6897a5dd3ef50fd3b290f56c.camel@redhat.com
Fixes: 35f834265e0d ("smb3: fix broken reconnect when password changing on the server by allowing password rotation")
Cc: stable@vger.kernel.org
Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/fs_context.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -164,6 +164,7 @@ const struct fs_parameter_spec smb3_fs_p
 	fsparam_string("username", Opt_user),
 	fsparam_string("pass", Opt_pass),
 	fsparam_string("password", Opt_pass),
+	fsparam_string("pass2", Opt_pass2),
 	fsparam_string("password2", Opt_pass2),
 	fsparam_string("ip", Opt_ip),
 	fsparam_string("addr", Opt_ip),
@@ -1041,6 +1042,9 @@ static int smb3_fs_context_parse_param(s
 		} else if (!strcmp("user", param->key) || !strcmp("username", param->key)) {
 			skip_parsing = true;
 			opt = Opt_user;
+		} else if (!strcmp("pass2", param->key) || !strcmp("password2", param->key)) {
+			skip_parsing = true;
+			opt = Opt_pass2;
 		}
 	}
 


