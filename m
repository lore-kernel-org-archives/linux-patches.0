Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59BED307AC7;
	Mon, 13 Apr 2026 16:40:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776098427; cv=none; b=cbgCbWgGaWA2ccFpgJ3XVML6vpqKMbOm22Je/Ve1P/OcQo2iyZl6l5I/KVDJmx2LGOOirlAnYJe0cQmLuSK7iAhWflzxO95H1Kc5KMMGPgqSNlDap/hASBG4VDqfKGbA/lst31xBYpTMBPkFazWSxfxUQ/fS0KTpwr4ETOXRdNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776098427; c=relaxed/simple;
	bh=yPq4z1PtD9YAdUbYmmPt6ui+V3AK73p5oEmHPkSpCbs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZtaTlp9FAJnVR+ZqaCI8qFOTeVbTjnxjrVAS9IpNJeDh19OsF5gbxa0kRDndKUXdCcKHiASbZWcT7q/oLaiI8cPt8PCzWiTkczweQNWTmOyYPTwiPdf0RmQSuC07l3iQDhBvvdTY01qZduSnieryYXuFH/75IqTQAazgp/ysdcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xG953eFJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xG953eFJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E51C9C2BCAF;
	Mon, 13 Apr 2026 16:40:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776098427;
	bh=yPq4z1PtD9YAdUbYmmPt6ui+V3AK73p5oEmHPkSpCbs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xG953eFJLefzFftcOUv8NOez2gzwSLtCirzX6MVaEBY/BYjew1cFFk4Cv+FynvI/a
	 EFzaMNVnUw8YFlw2joea6Euos/XuuDOheDyx5bYzpWvgJ/ht0q8mU00IhD42r/iNwg
	 uq2a6SxRzp3Fvp037jyRjMKAR896VB6UHsFAOJ6E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qualys Security Advisory <qsa@qualys.com>,
	Salvatore Bonaccorso <carnil@debian.org>,
	Georgia Garcia <georgia.garcia@canonical.com>,
	Cengiz Can <cengiz.can@canonical.com>,
	John Johansen <john.johansen@canonical.com>
Subject: [PATCH 5.15 521/570] apparmor: Fix double free of ns_name in aa_replace_profiles()
Date: Mon, 13 Apr 2026 18:00:52 +0200
Message-ID: <20260413155849.964854463@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Johansen <john.johansen@canonical.com>

commit 5df0c44e8f5f619d3beb871207aded7c78414502 upstream.

if ns_name is NULL after
1071         error = aa_unpack(udata, &lh, &ns_name);

and if ent->ns_name contains an ns_name in
1089                 } else if (ent->ns_name) {

then ns_name is assigned the ent->ns_name
1095                         ns_name = ent->ns_name;

however ent->ns_name is freed at
1262                 aa_load_ent_free(ent);

and then again when freeing ns_name at
1270         kfree(ns_name);

Fix this by NULLing out ent->ns_name after it is transferred to ns_name

Fixes: 145a0ef21c8e9 ("apparmor: fix blob compression when ns is forced on a policy load
")
Reported-by: Qualys Security Advisory <qsa@qualys.com>
Tested-by: Salvatore Bonaccorso <carnil@debian.org>
Reviewed-by: Georgia Garcia <georgia.garcia@canonical.com>
Reviewed-by: Cengiz Can <cengiz.can@canonical.com>
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/apparmor/policy.c |    1 +
 1 file changed, 1 insertion(+)

--- a/security/apparmor/policy.c
+++ b/security/apparmor/policy.c
@@ -917,6 +917,7 @@ ssize_t aa_replace_profiles(struct aa_ns
 				goto fail;
 			}
 			ns_name = ent->ns_name;
+			ent->ns_name = NULL;
 		} else
 			count++;
 	}


