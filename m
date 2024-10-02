Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97D701D0164;
	Wed,  2 Oct 2024 13:49:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876986; cv=none; b=gq/4a9Cr6AbmMjJHL6r85TAFek3pFrvYsUame2SymHT+5etpnUcgsKCGimrE9C1LAO4JzixEuA8NWpyNJg8PCC8eFg4BSLg+Z4X5KbnGiZl+Rjjf3XlAjnUdNJ7vnWvz3XrbgFZi/aWAMqWabMmKuaA7LMRzkiAs7L+WWqEnUoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876986; c=relaxed/simple;
	bh=lJynDomH8fWiGMcIRCNpMecJaDiH/hG0rk7pneYSysY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oEYdHbmA+Z+leepuSBzS0sdIhglBswGuc9fwcFAXL2ceRitZViAIavAQmoi9YuKmgYbyrtMiMirUoevV92YNQvwzkVvDePmKDZ89ymr30DvCavLBXtfgWty4vFACEuwecaEinuCdV5EN7sEQOpbJLT/xJYbDw7MWKPMtyFQ1h+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xK6BvsdA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xK6BvsdA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4142C4CEC2;
	Wed,  2 Oct 2024 13:49:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876986;
	bh=lJynDomH8fWiGMcIRCNpMecJaDiH/hG0rk7pneYSysY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xK6BvsdAk+H1hI4iiWsKrqZsmxqA5HO2N1poDtnow724Gsd5uytQ8Ie8H+8+UpY7M
	 YaMO3nTq6PHTpKkPv0zopcuDCtAB2t4nwC5P90eE+hNnxAGlBLTeNEDSFbwl9HLXKF
	 usC5nLcxgEpz3zeMCxyHP1JedUPReSrszCq3z8Xk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Marc=20Aur=C3=A8le=20La=20France?= <tsi@tuyoix.net>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 6.11 624/695] debugfs show actual source in /proc/mounts
Date: Wed,  2 Oct 2024 15:00:22 +0200
Message-ID: <20241002125847.419400054@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marc Aurèle La France <tsi@tuyoix.net>

commit 3a987b88a42593875f6345188ca33731c7df728c upstream.

After its conversion to the new mount API, debugfs displays "none" in
/proc/mounts instead of the actual source.  Fix this by recognising its
"source" mount option.

Signed-off-by: Marc Aurèle La France <tsi@tuyoix.net>
Link: https://lore.kernel.org/r/e439fae2-01da-234b-75b9-2a7951671e27@tuyoix.net
Fixes: a20971c18752 ("vfs: Convert debugfs to use the new mount API")
Cc: stable@vger.kernel.org # 6.10.x: 49abee5991e1: debugfs: Convert to new uid/gid option parsing helpers
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/debugfs/inode.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/fs/debugfs/inode.c
+++ b/fs/debugfs/inode.c
@@ -89,12 +89,14 @@ enum {
 	Opt_uid,
 	Opt_gid,
 	Opt_mode,
+	Opt_source,
 };
 
 static const struct fs_parameter_spec debugfs_param_specs[] = {
 	fsparam_gid	("gid",		Opt_gid),
 	fsparam_u32oct	("mode",	Opt_mode),
 	fsparam_uid	("uid",		Opt_uid),
+	fsparam_string	("source",	Opt_source),
 	{}
 };
 
@@ -126,6 +128,12 @@ static int debugfs_parse_param(struct fs
 	case Opt_mode:
 		opts->mode = result.uint_32 & S_IALLUGO;
 		break;
+	case Opt_source:
+		if (fc->source)
+			return invalfc(fc, "Multiple sources specified");
+		fc->source = param->string;
+		param->string = NULL;
+		break;
 	/*
 	 * We might like to report bad mount options here;
 	 * but traditionally debugfs has ignored all mount options


