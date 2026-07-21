Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9082347BC6;
	Tue, 21 Jul 2026 22:30:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673046; cv=none; b=eTrkp8ftxEN0NhOhOMM4m/y4oGCjmsl6S14B7hMRO0wy17cF7bncVk5+U8NgixWMl8hpgH3cSm1pyz1uDyn8Xi/0+8nF61iGDJBYGVbnMDAnSSsF+UdQg6OdtOXMOwPdYJECV929rSPnRYy2BBFXI28LlekLG15OjGkiVzYrAFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673046; c=relaxed/simple;
	bh=Jlut+b/VuqsHRpLkwZrCgfn2DFUS+rCzUf+nKI6yz3Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QMvywRwVTlOkDSgUCk8w3OYagb/9dzh1I5G2nbKG82W5EVse9Ul9CRSa9lOc0ycgzNqPoaJ98iH4oVHieeRzkECcKkK/GE3MDwZcV3D30oL4d9Y9kH2eoiS2RgLIJTYs17FoNvUwCzuXCdh3P6NlpL21rLr+LZNe6ekIV+pf1QE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LSUTnn9n; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LSUTnn9n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AD0F1F000E9;
	Tue, 21 Jul 2026 22:30:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673044;
	bh=5LM6j8H8ny3zPfvqqqRUFFXO3xtd3hRnssdF8lWiwA8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LSUTnn9naGI0SCoeAOuNkD00mZHK/DlK++aY/1+XOUQt3HydL6SyQmDNSuDEDk737
	 rZFYm85pB+n1K1mlNbDQ5WSnF5nGvpSqRcVLJHBMlK0UrcAaBhOkkuSXTv6CkZm3Io
	 ZGebNO9Rbow8C2edAh63zNzdmEy1i5FeAeIE1L7w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Colin Ian King <colin.i.king@gmail.com>,
	Ruslan Valiyev <linuxoid@gmail.com>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 015/699] apparmor: fix use-after-free in rawdata dedup loop
Date: Tue, 21 Jul 2026 17:16:14 +0200
Message-ID: <20260721152356.031951149@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

From: Ruslan Valiyev <linuxoid@gmail.com>

[ Upstream commit 6f060496d03e4dc560a40f73770bd08335cb7a27 ]

aa_replace_profiles() walks ns->rawdata_list to dedup the incoming
policy blob against entries already attached to existing profiles.
Per the kernel-doc on struct aa_loaddata, list membership does not
hold a reference: profiles hold pcount, and when the last pcount
drops, do_ploaddata_rmfs() is queued on a workqueue that takes
ns->lock and removes the entry. Between dropping the last pcount
and the workqueue running, an entry remains on the list with
pcount == 0.

aa_get_profile_loaddata() is an unconditional kref_get() on
pcount, so when the dedup loop hits such an entry, refcount
hardening reports

  refcount_t: addition on 0; use-after-free.

inside aa_replace_profiles(), and the poisoned counter then
trips "saturated" and "underflow" warnings on the subsequent
uses of the same loaddata.

Before commit a0b7091c4de4 ("apparmor: fix race on rawdata
dereference") the dedup path used a get_unless_zero-style helper
on a single counter, so the existing "if (tmp)" guard was
meaningful. The split-refcount refactor introduced
aa_get_profile_loaddata(), which has plain kref_get() semantics,
and the guard quietly became a no-op.

Introduce aa_get_profile_loaddata_not0(), matching the existing
_not0 convention used by aa_get_profile_not0(), and use it for
the rawdata_list dedup lookup so dying entries are skipped.

Reproduced on x86_64 with v7.1-rc5 in QEMU+KVM running Ubuntu
24.04 + stress-ng 0.17.06:

  stress-ng --apparmor 1 --klog-check --timeout 60s

Without this patch the three refcount_t warnings fire within a
few seconds. With it the same 60 s run is clean. Coverage is a
smoke-test only; a longer soak with CONFIG_KASAN, CONFIG_KCSAN
and CONFIG_PROVE_LOCKING would be welcome from anyone with the
cycles.

Fixes: a0b7091c4de4 ("apparmor: fix race on rawdata dereference")
Reported-by: Colin Ian King <colin.i.king@gmail.com>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=221513
Cc: stable@vger.kernel.org
Signed-off-by: Ruslan Valiyev <linuxoid@gmail.com>
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/apparmor/include/policy_unpack.h |   19 +++++++++++++++++++
 security/apparmor/policy.c                |    8 ++++++--
 2 files changed, 25 insertions(+), 2 deletions(-)

--- a/security/apparmor/include/policy_unpack.h
+++ b/security/apparmor/include/policy_unpack.h
@@ -122,6 +122,25 @@ aa_get_profile_loaddata(struct aa_loadda
 	return data;
 }
 
+/**
+ * aa_get_profile_loaddata_not0 - get a profile reference count if not zero
+ * @data: reference to get a count on
+ *
+ * Like aa_get_profile_loaddata(), but safe to call on an entry that may
+ * be on a list (e.g. ns->rawdata_list) where the last pcount has already
+ * dropped and the deferred cleanup has not yet run.
+ *
+ * Returns: pointer to reference, or %NULL if @data is NULL or its
+ *          profile refcount has already reached zero.
+ */
+static inline struct aa_loaddata *
+aa_get_profile_loaddata_not0(struct aa_loaddata *data)
+{
+	if (data && kref_get_unless_zero(&data->pcount))
+		return data;
+	return NULL;
+}
+
 void __aa_loaddata_update(struct aa_loaddata *data, long revision);
 bool aa_rawdata_eq(struct aa_loaddata *l, struct aa_loaddata *r);
 void aa_loaddata_kref(struct kref *kref);
--- a/security/apparmor/policy.c
+++ b/security/apparmor/policy.c
@@ -976,8 +976,12 @@ ssize_t aa_replace_profiles(struct aa_ns
 		if (aa_rawdata_eq(rawdata_ent, udata)) {
 			struct aa_loaddata *tmp;
 
-			tmp = aa_get_profile_loaddata(rawdata_ent);
-			/* check we didn't fail the race */
+			/*
+			 * Entries remain on rawdata_list with
+			 * pcount == 0 until do_ploaddata_rmfs()
+			 * runs; only take a live profile ref.
+			 */
+			tmp = aa_get_profile_loaddata_not0(rawdata_ent);
 			if (tmp) {
 				aa_put_profile_loaddata(udata);
 				udata = tmp;


