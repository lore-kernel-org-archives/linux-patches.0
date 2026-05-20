Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 676DE3F23D1;
	Wed, 20 May 2026 17:03:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296596; cv=none; b=lMZjw3E3pX4cLmnmYbb3WxwAEJIAGqvuh1WYzPpB3SAErOlnrpprqW9TzJqPN59CsACa43HpFxsJw1tcwff6YC+UmPZTjDZh0PUJ7PPL2B4qf9KVsHFyl2GATA2DZ2lwffWsgY5r6Nhk8pfmXz2+5YnY8zoq2/7CcofW8SxxEB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296596; c=relaxed/simple;
	bh=sS5tYcefoZLJxDDBAXEDtAZvDbiVwex9C4rV4kB6LII=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KtUapZpZjRWfCEGGyfPhFd/h80b8WvijZMpNorDe0uTF/iZ5yIqeF5PGHGfcIa20itvlLEF3ynzcAUTJBilraWsBt0Nz7hY8Ez+fhirTKNiU7yjAb82E4gQtiN/AyiGve4A6CvRBRvkFqjTMV+AUSi3K1LC3xKry3qI8EyCsybU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BBEg9DZg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BBEg9DZg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C76EE1F00893;
	Wed, 20 May 2026 17:03:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296593;
	bh=rDFeibUu75/AIG6Hvt6kPSTo/Wd+l0ZiYSJ5i4lkoV8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BBEg9DZg7R66Sm5A19sV9DiunY0z9XfBCtSxsOgAYKOk7fb781Xga7pj3WvtYYsE4
	 Lf8R85UbehSj8fy2sKgp3JFG9i41t10a8cHE+aXILkg+6ZLMD8TnpGpHktH9L5dsdr
	 ZFa8Z9t4QQ55yLJYpfbS36EJj50AtkkhbHPpCdlU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Kodanev <aleksei.kodanev@bell-sw.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0857/1146] nfp: fix swapped arguments in nfp_encode_basic_qdr() calls
Date: Wed, 20 May 2026 18:18:27 +0200
Message-ID: <20260520162207.633868755@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexey Kodanev <aleksei.kodanev@bell-sw.com>

[ Upstream commit 4078c5611d7585548b249377ebd60c272e410490 ]

There is a mismatch between the passed arguments and the actual
nfp_encode_basic_qdr() function parameter names:

  static int nfp_encode_basic_qdr(u64 addr, int dest_island, int cpp_tgt,
                                  int mode, bool addr40, int isld1,
                                  int isld0)
  {
      ...

But "dest_island" and "cpp_tgt" are swapped at every call-site.
For example:

  return nfp_encode_basic_qdr(*addr, cpp_tgt, dest_island,
                              mode, addr40, isld1, isld0);

As a result, nfp_encode_basic_qdr() receives "dest_island" as CPP target
type, which is always NFP_CPP_TARGET_QDR(2) for these calls, and "cpp_tgt"
as the destination island ID, which can accidentally match or be outside
the valid NFP_CPP_TARGET_* types (e.g. '-1' for any destination).

Since code already worked for years, also add extra pr_warn() to error
paths in nfp_encode_basic_qdr() to help identify any potential address
verification failures.

Detected using the static analysis tool - Svace.

Fixes: 4cb584e0ee7d ("nfp: add CPP access core")
Signed-off-by: Alexey Kodanev <aleksei.kodanev@bell-sw.com>
Link: https://patch.msgid.link/20260422160536.61855-1-aleksei.kodanev@bell-sw.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/netronome/nfp/nfpcore/nfp_target.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_target.c b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_target.c
index 79470f198a62a..9cf19446657c6 100644
--- a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_target.c
+++ b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_target.c
@@ -435,12 +435,17 @@ static int nfp_encode_basic_qdr(u64 addr, int dest_island, int cpp_tgt,
 
 	/* Full Island ID and channel bits overlap? */
 	ret = nfp_decode_basic(addr, &v, cpp_tgt, mode, addr40, isld1, isld0);
-	if (ret)
+	if (ret) {
+		pr_warn("%s: decode dest_island failed: %d\n", __func__, ret);
 		return ret;
+	}
 
 	/* The current address won't go where expected? */
-	if (dest_island != -1 && dest_island != v)
+	if (dest_island != -1 && dest_island != v) {
+		pr_warn("%s: dest_island mismatch: current (%d) != decoded (%d)\n",
+			__func__, dest_island, v);
 		return -EINVAL;
+	}
 
 	/* If dest_island was -1, we don't care where it goes. */
 	return 0;
@@ -493,7 +498,7 @@ static int nfp_encode_basic(u64 *addr, int dest_island, int cpp_tgt,
 			 * the address but we can verify if the existing
 			 * contents will point to a valid island.
 			 */
-			return nfp_encode_basic_qdr(*addr, cpp_tgt, dest_island,
+			return nfp_encode_basic_qdr(*addr, dest_island, cpp_tgt,
 						    mode, addr40, isld1, isld0);
 
 		iid_lsb = addr40 ? 34 : 26;
@@ -504,7 +509,7 @@ static int nfp_encode_basic(u64 *addr, int dest_island, int cpp_tgt,
 		return 0;
 	case 1:
 		if (cpp_tgt == NFP_CPP_TARGET_QDR && !addr40)
-			return nfp_encode_basic_qdr(*addr, cpp_tgt, dest_island,
+			return nfp_encode_basic_qdr(*addr, dest_island, cpp_tgt,
 						    mode, addr40, isld1, isld0);
 
 		idx_lsb = addr40 ? 39 : 31;
@@ -530,7 +535,7 @@ static int nfp_encode_basic(u64 *addr, int dest_island, int cpp_tgt,
 			 * be set before hand and with them select an island.
 			 * So we need to confirm that it's at least plausible.
 			 */
-			return nfp_encode_basic_qdr(*addr, cpp_tgt, dest_island,
+			return nfp_encode_basic_qdr(*addr, dest_island, cpp_tgt,
 						    mode, addr40, isld1, isld0);
 
 		/* Make sure we compare against isldN values
@@ -551,7 +556,7 @@ static int nfp_encode_basic(u64 *addr, int dest_island, int cpp_tgt,
 			 * iid<1> = addr<30> = channel<0>
 			 * channel<1> = addr<31> = Index
 			 */
-			return nfp_encode_basic_qdr(*addr, cpp_tgt, dest_island,
+			return nfp_encode_basic_qdr(*addr, dest_island, cpp_tgt,
 						    mode, addr40, isld1, isld0);
 
 		isld[0] &= ~3;
-- 
2.53.0



