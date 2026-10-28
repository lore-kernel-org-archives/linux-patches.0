Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208123;
	b=icsRIrIpDLscpYrig6r5ls46/hldAPQTQozGlnvDLBl4B4ma2Jsk+IOwu5FdhKVgo7Ob
	 vKhs0+I7dGFc/2AQc5d9EMgEPF7Y/MRdWFKYqkVcJS18U+AcCtDTG2B8H77Jjfsu+vz2c
	 FllT0AHATeAdAr6JebsxpOBNuMs7SASkIKNi4RwxNeHFqCjUln4ersQWv33G/KEOSXtLd
	 YokUJWa8dFTUGouN3vUHMABxDZUjD5V1PLYdY9RtHF7rlvxVGmA8n3YHDueREsuYNvc8I
	 zb1IlDvWr6FdfEZ+godHlGBuS3WHq6DcDDBxvDEziDkjrjINdowGd418nPaeyQCtLKA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208123;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KeykT/ThodXxARSrYgTpVKPGyHjOE+8KzMUU7CyTBFg=;
	b=IDSTQ/f5AKHRmtfgfBAj8UcbDIh9y/H6iOvKZRCtaBx5V8eQUq+j9Oe3NliDlWNtKugz
	 keCigk0ixiziAFWlCSGTRsN6GP3z7ZpPrW0QVvCDUBc4U0mB6QFea3Nvc8TwCS4ezbpOb
	 bNlz9udotXiCKaddfKa2+esjcChXk0FN9a3QuVHx4G3AMr4VBVa5av9YVpThrFsbXbY66
	 vh0boA/gBm7DeC04LX4wMPPCRIDi3rgPJTRnR4SZO5qmrnH8fDGZW9s37EfJCeXOSMGJk
	 MOQOxRrJ/FNnjLWiPXj9fJPzLolhjNO8QdDw/Ksn44NxUxeFCnZyHM3cxZrouIVpkMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=M5+mvh0e;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C952606A31E;
	Wed, 28 Oct 2026 17:22:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=M5+mvh0e
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE1B21F031E2;
	Wed, 28 Oct 2026 17:22:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208123;
	bh=KeykT/ThodXxARSrYgTpVKPGyHjOE+8KzMUU7CyTBFg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M5+mvh0eYDU1gr0t26fiAIHfMR6I0M3ggjRjcwyc0dkVWqBnDDZ+Jl/I9dU+Iyazg
	 oPBr7mAU/2FFHmuArg5Zyn3q0mBG1Xt+JS3xepDyeYVT3uSRqT4F0CNJnuVf++lAZb
	 fEXOmbWFIdTMEG2rpgbHJ1OEUAYJ75yGffhpYxwo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunwoo Kim <imv4bel@gmail.com>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 002/516] apparmor: fix out-of-bounds write when null terminating a label vec
Date: Wed, 28 Oct 2026 17:52:34 +0100
Message-ID: <20261028170003.584981324@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

From: Hyunwoo Kim <imv4bel@gmail.com>

[ Upstream commit 9f1e40193eef7f047e6b77cfb4b4cafdecd7a123 ]

aa_vec_unique() null terminates at vec[n - dups] when VEC_FLAG_TERMINATE
is passed. If the components are all distinct no duplicates are dropped,
dups is 0 and the terminator goes to vec[n], so the caller has to provide
room for n + 1 entries.

aa_label_strn_parse() sets up its vector with vec_setup(profile, vec, len,
gfp) and then calls aa_vec_unique(vec, len, VEC_FLAG_TERMINATE), but
vec_setup() does not reserve the terminator entry. Up to LOCAL_VEC_ENTRIES
it uses the local array of LOCAL_VEC_ENTRIES pointers, above that it
allocates exactly len pointers. The terminator therefore lands one entry
past the end of the local array when len is LOCAL_VEC_ENTRIES, and one
entry past the end of the allocation when len is larger.

len comes from the number of "//&" separated components in the label name
and label_count_strn_entries() does not bound it. An unprivileged task
reaches the parse by writing to /proc/self/attr/apparmor/current or through
lsm_set_self_attr(2), both of which go through do_setattr(), and the name
is parsed before the change_profile permission is checked.
The query_label() path behind the securityfs .access file, which is
mode 0666, performs no permission check at all. Every component has to
resolve to a loaded profile, so a system with policy loaded is required.

The other two VEC_FLAG_TERMINATE users work on a label vec that
aa_label_alloc() has already sized with "+ 1 for null terminator entry on
vec". Reserve the same entry in vec_setup() and DEFINE_VEC(). Passing
len + 1 from the caller instead would move len == LOCAL_VEC_ENTRIES out of
the local array and into kzalloc().

Fixes: f1bd904175e8 ("apparmor: add the base fns() for domain labels")
Cc: stable@vger.kernel.org
Signed-off-by: Hyunwoo Kim <imv4bel@gmail.com>
Signed-off-by: John Johansen <john.johansen@canonical.com>
[ replaced unavailable kzalloc_objs() with equivalent kcalloc() allocation ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/apparmor/include/label.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/security/apparmor/include/label.h b/security/apparmor/include/label.h
index 55986388dfaeb..a987bd117d88d 100644
--- a/security/apparmor/include/label.h
+++ b/security/apparmor/include/label.h
@@ -22,7 +22,7 @@ struct aa_ns;
 
 #define LOCAL_VEC_ENTRIES 8
 #define DEFINE_VEC(T, V)						\
-	struct aa_ ## T *(_ ## V ## _localtmp)[LOCAL_VEC_ENTRIES];	\
+	struct aa_ ## T *(_ ## V ## _localtmp)[LOCAL_VEC_ENTRIES + 1];	\
 	struct aa_ ## T **(V)
 
 #define vec_setup(T, V, N, GFP)						\
@@ -30,10 +30,10 @@ struct aa_ns;
 	if ((N) <= LOCAL_VEC_ENTRIES) {					\
 		typeof(N) i;						\
 		(V) = (_ ## V ## _localtmp);				\
-		for (i = 0; i < (N); i++)				\
+		for (i = 0; i <= (N); i++)				\
 			(V)[i] = NULL;					\
 	} else								\
-		(V) = kzalloc(sizeof(struct aa_ ## T *) * (N), (GFP));	\
+		(V) = kcalloc((N) + 1, sizeof(struct aa_ ## T *), (GFP)); \
 	(V) ? 0 : -ENOMEM;						\
 })
 
-- 
2.53.0



