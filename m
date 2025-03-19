Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3602818BC36;
	Wed, 19 Mar 2025 14:40:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395252; cv=none; b=U9ayXu3x/thNbTfvStOB4T5IhTBruEoU4KhRKCIkXwwX3p9rodbu/XP17HUNbRGcaqJJL2h5RZzMLg+2xK01ZGH1Vb48MInXfJJ5jaX0RzdIeNz+Qa7shkOQUvdFQRJVuTGKuTtNPdiXanc1IlEQQ6aXa3BoCPAubbK/Ed3DtxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395252; c=relaxed/simple;
	bh=8lJ1gcrweoaNa+PI0ugq/R4MVKVLy/8/t69PmHIzQVs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bE+R1+dlpLRo1UXOG7Z/p8G4iXkyIDpEmJo2yLtcPVog6n6QCz97TZC/Nil380GrOErp0HFAFpVlMzVbD0+yGU+50ece35XBlcb+myPAfUK0UQPQx53Ny3axdsiI+CQAY28nXsfKryTHrjZVJpXpeLbbnZj//vmY0/NsNAtex24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1XOGB50V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1XOGB50V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09A64C4CEE4;
	Wed, 19 Mar 2025 14:40:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395252;
	bh=8lJ1gcrweoaNa+PI0ugq/R4MVKVLy/8/t69PmHIzQVs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1XOGB50VmE4HCwHYH4kSPDWJpaM6g/FLKWAilFfoOal4U3ed1JmfrDCe4p78h8sjb
	 8SSRVzkJQodStBK8OJFuoSxoocNsuRiLzMkYSMF7TBcY0BbhoTBmd3SeEA8scIvwSM
	 Hn71b8aov3b6xAveUUfmb/DtjbrdYX/ct/luOVJs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adam Williamson <awilliam@redhat.com>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.6 134/166] smb: client: fix regression with guest option
Date: Wed, 19 Mar 2025 07:31:45 -0700
Message-ID: <20250319143023.645222607@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143019.983527953@linuxfoundation.org>
References: <20250319143019.983527953@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -162,6 +162,7 @@ const struct fs_parameter_spec smb3_fs_p
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
 


