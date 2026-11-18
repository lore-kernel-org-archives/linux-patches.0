Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045920;
	b=tkUxw8aK7ja4JzSsH428VY/aojdBsYLzA0cuZ+syWERjvXENSDOPQVUOpoSsTSs2SnCp
	 ghl66nlesG243W2YTypzikRyerENUql8GlNWaz512hh9L4c0qo92+ahLQokDB1yGrmV6A
	 bfm/0jpB5YesktOnNuYWLcg+pFIJ5xc95AGNOvS2mdiFc4fmhXsc8BG4wQKU1oF96j2b2
	 Vuuv1rzjTdHgnIW2VYfYHllx0ny7VNMUMAFbtGVwdjjvGQKG4r58W/gEYFK6RyzzwYuui
	 nOeUjcmUQdtffosdYjpOhpa4KEyXm1eNlZ3lSg6kc8htdrIckKpbc490IrMWtvEYtNQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045920;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JO41x79heyV9fHNa30QW3Uxucns60YJc+Z5OMZuOwcc=;
	b=M7i5wnG8sVNV4iXDjd1vo+DkC0GJnNvP6M2dpSBK6PVFBFKCVjGIAdbQZ2aRPpN22FTQ
	 Qwd9bycIFFcrt0gW4WpQcmRdkfqnZOlicZXJUpwBMlH+OHldj5sN4AHho7JKHiZBhmRWV
	 rO9aWnZeIcA2nHoZAFxpOxcLfQ3tAZiPmLTWfIRQlPTHCsKYw+RQ53PCN3X4+hvekMG57
	 XjLPacaH5RxxGEB+KdzULtenlUov/fbzaYzjgwqug5G127JtF52ZEL5FbbsbRz9bMNkeH
	 rRHiDLoM7KFClWJ7sQ/gLalDfMjKHTvojicPGHVdfD7EwdNrEymsbWkEMIUQnAuOCpg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qyS1Gywq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9433606A325;
	Wed, 18 Nov 2026 23:52:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qyS1Gywq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0689C1F000C4;
	Wed, 18 Nov 2026 23:51:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045920;
	bh=JO41x79heyV9fHNa30QW3Uxucns60YJc+Z5OMZuOwcc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qyS1Gywq1BT+eeEzdAN7jl7pls7tSR6jEjsMqh0Zm31tV6vbSuUBb1MxI4CJHkWZ4
	 7m8/w5V87u0MeY4kdFlbuJej3rPAN9FocEzIqMNQyDJvJG3ujYpaXPkgqk3eu7LKtq
	 t1aW0XYZoYvRj104ueqamZ0wAvPTW4ZKSidr9FJE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Georgia Garcia <georgia.garcia@canonical.com>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1096/2857] apparmor: remove fs entries created by a failed policy load
Date: Wed, 18 Nov 2026 15:35:30 +0100
Message-ID: <20261118150241.089282556@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Georgia Garcia <georgia.garcia@canonical.com>

[ Upstream commit 6ec46f8f1977d218bf2494ce276152b2d01424af ]

aa_replace_profiles() creates the raw_data/<rev> directory for the
loaddata and the profile directories for new profiles before the last
checks that can fail. When one of those checks fails, the fail path
releases the ns lock without removing what this load created.

The raw_data directory is named after the current ns revision, and the
revision is only bumped by a successful load. The stale directory is
only removed once the loaddata's last profile reference is dropped, from
a workqueue. Until then, every load fails to create raw_data/<rev> with
-EEXIST. If the new profiles are never freed, which is the case when
their dents are left behind pinning the proxy, that never happens and no
policy can be loaded until reboot.

While still holding the ns lock in the fail path, remove the profile
directories of the new profiles and, if this load created it, the
raw_data directory.

Fixes: 5d5182cae401 ("apparmor: move to per loaddata files, instead of replicating in profiles")
Cc: stable@vger.kernel.org
Signed-off-by: Georgia Garcia <georgia.garcia@canonical.com>
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/apparmor/policy.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/security/apparmor/policy.c b/security/apparmor/policy.c
index 13d3041200cba..c129f13fdeec6 100644
--- a/security/apparmor/policy.c
+++ b/security/apparmor/policy.c
@@ -974,6 +974,7 @@ ssize_t aa_replace_profiles(struct aa_ns *policy_ns, struct aa_label *label,
 	struct aa_loaddata *rawdata_ent;
 	const char *op;
 	ssize_t count, error;
+	bool rawdata_created = false;
 	LIST_HEAD(lh);
 
 	op = mask & AA_MAY_REPLACE_POLICY ? OP_PROF_REPL : OP_PROF_LOAD;
@@ -1095,6 +1096,7 @@ ssize_t aa_replace_profiles(struct aa_ns *policy_ns, struct aa_label *label,
 			ent = NULL;
 			goto fail_lock;
 		}
+		rawdata_created = true;
 	}
 	list_for_each_entry(ent, &lh, list) {
 		if (!ent->old) {
@@ -1175,6 +1177,18 @@ ssize_t aa_replace_profiles(struct aa_ns *policy_ns, struct aa_label *label,
 	return udata_sz;
 
 fail_lock:
+	/*
+	 * Remove fs entries created by this load. Nothing else references
+	 * them yet, and leaving them behind would leak the new profiles
+	 * (their dents pin the proxy) and make the next load at the same,
+	 * unbumped ns revision fail with -EEXIST on its raw_data dir.
+	 */
+	list_for_each_entry(tmp, &lh, list) {
+		if (!tmp->old)
+			__aafs_profile_rmdir(tmp->new);
+	}
+	if (rawdata_created)
+		__aa_fs_remove_rawdata(udata);
 	mutex_unlock(&ns->lock);
 
 	/* audit cause of failure */
-- 
2.53.0



