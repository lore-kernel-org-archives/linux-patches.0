Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A38940244D;
	Tue, 21 Jul 2026 17:28:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654935; cv=none; b=rPaaxT1Mv4unBQ9mhfhO3VKhYwxyPpn8y3mE1vHMv/suPTQSMxKvEFIWBsO2TItkSfTs/t4c4Nn1/CHLDGGO9gj+xttkrYNETcrcvCypLJzc+r3LVzdMNAWlTGSd4VZ1aHIkN2Hm9CUqb6dIX4P2pk9d9zIkegT5EsTbUznDmbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654935; c=relaxed/simple;
	bh=z7qzKk97WMdIgr70VnOYA58ujquYIVudBx2VubnEBFo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l2xYSEk6zBrlwE42APy9MUhubwBnDRY4hi+Agyavbu5om/gCi1UIXWaGjhBCfp+/u5Xskqib8OMregKxLCK+LVITQtAcR1ymxvzAMnjWKs1Q5bpMeUqaCN40//2QVNxJQcAiwwCItLnwDb3BbtZWMnIkRxATkfJVblmuV2mu6dc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fWwiEyNT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fWwiEyNT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66BC71F000E9;
	Tue, 21 Jul 2026 17:28:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654933;
	bh=mT3b8zEoDBdf4s1lf6HF+lVQORbPVqKMrA9TPDtVtig=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fWwiEyNTmxUzXFNDer9fYPwsCPuolekQXaC6lD4twXOEjTaxTh3hRn1d2dub5DDtb
	 Rld5/IUh8qmyw44Yf1VEFj7a8sUu7ENGdITVHThO3KvIfqXH6ZBBFqox+cGeCflYcD
	 /hr/xMw4bV07f5LvRV724CWcSrXl6RgY1dcCWN/4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samuel Moelius <sam.moelius@trailofbits.com>,
	Zheng Gu <cengku@gmail.com>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 7.1 1849/2077] dm-pcache: reject option groups without values
Date: Tue, 21 Jul 2026 17:25:22 +0200
Message-ID: <20260721152636.349261433@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Samuel Moelius <sam.moelius@trailofbits.com>

commit d9c631e3fbd44246a2be781d26cfacbb9b8ec127 upstream.

The pcache target parses optional arguments as name/value pairs.  A
table that advertises one optional argument and supplies only a
recognized option name, for example "cache_mode", reaches
parse_cache_opts() with argc == 1.  The parser consumes the name,
decrements argc to zero, then calls dm_shift_arg() again for the value.
dm_shift_arg() returns NULL when no arguments remain, and the following
strcmp() dereferences that NULL pointer.

Check that each recognized option has a value before consuming it.  This
keeps valid "cache_mode writeback" and "data_crc true/false" tables
unchanged while making malformed tables fail during target construction
with a precise missing-value error.

Assisted-by: Codex:gpt-5.5-cyber-preview
Signed-off-by: Samuel Moelius <sam.moelius@trailofbits.com>
Reviewed-by:  Zheng Gu <cengku@gmail.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Fixes: 1d57628ff95b ("dm-pcache: add persistent cache target in device-mapper")
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-pcache/dm_pcache.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/md/dm-pcache/dm_pcache.c
+++ b/drivers/md/dm-pcache/dm_pcache.c
@@ -168,6 +168,10 @@ static int parse_cache_opts(struct dm_pc
 		argc--;
 
 		if (!strcmp(arg, "cache_mode")) {
+			if (!argc) {
+				*error = "Missing value for cache_mode";
+				return -EINVAL;
+			}
 			arg = dm_shift_arg(as);
 			if (!strcmp(arg, "writeback")) {
 				opts->cache_mode = PCACHE_CACHE_MODE_WRITEBACK;
@@ -177,6 +181,10 @@ static int parse_cache_opts(struct dm_pc
 			}
 			argc--;
 		} else if (!strcmp(arg, "data_crc")) {
+			if (!argc) {
+				*error = "Missing value for data_crc";
+				return -EINVAL;
+			}
 			arg = dm_shift_arg(as);
 			if (!strcmp(arg, "true")) {
 				opts->data_crc = true;


