Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058813;
	b=E9flshxZVBNt9tr2bm4s2Gb6UwiEpeiLoOadCUoiLCnsxBk72Zh7/bGRL0TO4ckF+AVs
	 T5XrCs8BSSuXOjD4fJmlr6tPw5O8v/z5rgPgfWtPeNqu1sBvjahm3anArvDtJNOXgTP3c
	 18wWjS/77tedvU5I0ydhVtDNWMf+2iWJaDbDtol898Rrh45tqQuwR3ntlCkC3MQg99/UD
	 NnPyPXr/BoPRdBOUL430MCEBGb65nAULGMi3zTU49P5EWBmzd4GcF+OUtbo7lB+X6wdGL
	 vHU3KLSHeIb32anoSFtinZhsnE7bgPMmBVOKfaqubYmVZC/8IU5/jNU56wWKnOvl+ew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058813;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=K7Y7k7p9ttDsphjw2+VKONdksnEtE3e2nGiEAPJr41I=;
	b=0k/tMH/6O4IsOvdQ2OGe2JFmucdSV4Ce+EHuSN7WTLy4nnRMeRa6zvvtIJSgnSzjzSWr
	 Ci/eLakj9TQnNOSuC5UyzxEjLXaA2QmrCrtkZFGIrgK0DYaZS3OuKHft55LXdLnctARKB
	 3QsUWYJZwKcDD4qxm4R7rGGamfX4O+qlgTg6bE+zqegheF+9J8DiyYdPFm9oqBAt3x6zC
	 2fSM6fl8kr+66juzEygt1IvSgM5ovvFjwmWaCuVX9ErO82YNdGQ9afGjHdOS8aUPdCS7B
	 Ft0niP5pJEMmYGKPnaF8LfKJY7e7qIYHH+nGc3eNc6z6AZy3+ssORHDwwS8NYBMjdcw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0+lXkAbM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D55EB606A326;
	Thu, 19 Nov 2026 03:26:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0+lXkAbM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 338B31F000C4;
	Thu, 19 Nov 2026 03:26:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058813;
	bh=K7Y7k7p9ttDsphjw2+VKONdksnEtE3e2nGiEAPJr41I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0+lXkAbMslfEVjyR2Iq2QsJi7CvG4exFC0OI3LLXIw9QPsoBcBPM+cXADeWwACS6A
	 p+dwfA+p5taa9TLhMvuvxQ8EAlgc4HttQX/ni1bPfLvTPQxkHkdfLNz2yREyQ2WC4F
	 eyldua8BjnU3T0T+iAy8O/sfp65huLJhn9+7lis4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Raphael Zimmer <raphael.zimmer@tu-ilmenau.de>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0578/1848] libceph: Fix multiple unsafe decodes in ceph_oloc_decode()
Date: Wed, 18 Nov 2026 15:43:36 +0100
Message-ID: <20261118145939.387319567@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Raphael Zimmer <raphael.zimmer@tu-ilmenau.de>

[ Upstream commit 10655007b9b679e46a9e383202c7bb791e5d1d13 ]

ceph_oloc_decode handles unchecked data received over the network from
an OSD. Currently, there are multiple decode operations that aren't
covered by any bounds check. Decoding these fields can therefore result
in out-of-bounds reads if a corrupted message is received.

This patch fixes the issue by adding bounds checks covering all
previously uncovered decode operations.

[ idryomov: use ceph_decode_64_safe() for hash ]

Cc: stable@vger.kernel.org
Fixes: 205ee1187a67 ("libceph: follow redirect replies from osds")
Assisted-by: Cursor
Signed-off-by: Raphael Zimmer <raphael.zimmer@tu-ilmenau.de>
Reviewed-by: Alex Markuze <amarkuze@redhat.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ceph/osd_client.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
index ae530f1248d89..140a7ec1b0553 100644
--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -3503,6 +3503,7 @@ static int ceph_oloc_decode(void **p, void *end,
 	ceph_decode_need(p, end, len, e_inval);
 	struct_end = *p + len;
 
+	ceph_decode_need(p, end, 8 + 4 + 4, e_inval);
 	oloc->pool = ceph_decode_64(p);
 	*p += 4; /* skip preferred */
 
@@ -3515,7 +3516,7 @@ static int ceph_oloc_decode(void **p, void *end,
 	if (struct_v >= 5) {
 		bool changed = false;
 
-		len = ceph_decode_32(p);
+		ceph_decode_32_safe(p, end, len, e_inval);
 		if (len > 0) {
 			ceph_decode_need(p, end, len, e_inval);
 			if (!oloc->pool_ns ||
@@ -3534,7 +3535,9 @@ static int ceph_oloc_decode(void **p, void *end,
 	}
 
 	if (struct_v >= 6) {
-		s64 hash = ceph_decode_64(p);
+		s64 hash;
+
+		ceph_decode_64_safe(p, end, hash, e_inval);
 		if (hash != -1) {
 			pr_warn("ceph_object_locator::hash is set\n");
 			goto e_inval;
-- 
2.53.0



