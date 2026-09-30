Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2456E3C3F56;
	Wed, 30 Sep 2026 19:16:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795806; cv=none; b=R7jDc3GakUQqpebyt7rCODvGZ5Cmwe24l5ilned1djBqf4T6qaMlcdGQEgGzMO11lBNBS+3QOjekxoGkW7MHqzbjNbiA1bAp1Cu3L86zVXJYRe9DNdGWh/9kKKi55gbkTHuOF0MMhmdlieWkL8xh9FaLgvg42MjjZqFVSGstgTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795806; c=relaxed/simple;
	bh=xSgE8QhzfxTsOUTaXULk1cGfdYx6vCbvxnoESgk0Res=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h0EkGXmIu5hZE7hz08wZiAHSftFIFSR6ZC0nksC11DUFNGU86Vc1wghjOjcrCmYUx+ayhkNkkmdpHr3FvoRH0DxzyQE5//gI/UnvunmFO2lGd9xbpZtUyFMEkSCsJ+FnGlZVTkEJbqf4OCXPhchibSl2JtoQNW2KWQ6hQGzTuV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=li8m+ZFR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="li8m+ZFR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 789A61F000FF;
	Wed, 30 Sep 2026 19:16:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795805;
	bh=s8DsR01ElrClg+EMkyDtL2/yI+BAOYAdAm8bOYnknZI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=li8m+ZFRhfNgZIm99B3lRl7JV1v9vKJ0ZBtdKs9ynnFN30hcH94mJ9LYnq0DJvr9H
	 zHgi72doQ8azCCd/s/twvE6WH9OkKNBsWyOpgat/7Z/SLz7XOUzdZxbZDCbQ+Jh0fC
	 tEkXYuf2h1YimMB5ODc0u2uAsaGHE9atn8bF0gR8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	TencentOS Corvus AI <corvus@tencent.com>,
	Aohan Mei <henrymei@tencent.com>,
	David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>
Subject: [PATCH 6.6 0663/1193] smb: client: reject userspace cifs.idmap descriptions
Date: Wed, 30 Sep 2026 17:22:27 +0200
Message-ID: <20260930152448.967734497@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aohan Mei <henrymei@tencent.com>

commit d9d7eeb0cea5b55b82888f443622fd8d4ee064f3 upstream.

cifs.idmap key descriptions carry authority-bearing fields (owner and
group SIDs and uid/gid values in "os:"/"gs:"/"oi:"/"gi:" form) that the
cifs.idmap upcall helper treats as kernel-originating inputs.  Unlike
its sibling cifs.spnego, the cifs.idmap key type has no vet_description
hook, so userspace can create keys of this type through
request_key(2)/add_key(2) and supply those fields without CIFS origin.
A request_key(2) call with a non-NULL callout then drives a root
usermodehelper upcall (/sbin/request-key -> cifs.idmap) that consumes
the unvetted description in root context.

Only accept cifs.idmap descriptions while CIFS is using its private
root_cred to request the key.  id_to_sid()/sid_to_id() already run
under override_creds(root_cred), so the kernel-originated path is
unaffected.

This mirrors commit 3da1fdf4efbc ("smb: client: reject userspace
cifs.spnego descriptions"), which applied the same restriction to
cifs.spnego.

Fixes: 4d79dba0e007 ("cifs: Add idmap key and related data structures and functions (try #17 repost)")
Reported-by: TencentOS Corvus AI <corvus@tencent.com>
Cc: stable@vger.kernel.org
Assisted-by: CodeBuddy:Kimi-K3
Signed-off-by: Aohan Mei <henrymei@tencent.com>
Acked-by: David Howells <dhowells@redhat.com>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/cifsacl.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

--- a/fs/smb/client/cifsacl.c
+++ b/fs/smb/client/cifsacl.c
@@ -101,8 +101,23 @@ cifs_idmap_key_destroy(struct key *key)
 		kfree(key->payload.data[0]);
 }
 
+static int
+cifs_idmap_key_vet_description(const char *description)
+{
+	/*
+	 * cifs.idmap descriptions are authority-bearing inputs to the
+	 * cifs.idmap upcall helper.  Only allow the kernel to create this
+	 * type of key using the private root_cred installed in
+	 * init_cifs_idmap; reject userspace request_key(2)/add_key(2).
+	 */
+	if (current_cred() != root_cred)
+		return -EPERM;
+	return 0;
+}
+
 static struct key_type cifs_idmap_key_type = {
 	.name        = "cifs.idmap",
+	.vet_description = cifs_idmap_key_vet_description,
 	.instantiate = cifs_idmap_key_instantiate,
 	.destroy     = cifs_idmap_key_destroy,
 	.describe    = user_describe,


