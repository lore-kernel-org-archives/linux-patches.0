Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 468E54E1C76;
	Wed, 30 Sep 2026 16:27:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790785678; cv=none; b=kDiU/8pRLLi9tq7q7WOVxeXY5h4y92hbNXqP2Rx9ti5IWUJKvpfEbXLIg+jKZtmFNbQkuDLo9jt2L5yM42hAKLClFNRHk1Qo0gq9OsdNZhnrlZNUn5UqpokBpzYPOWuQVGh4p+Qxo0K0N6M818i3y9T+Dt3qeb2U6TMAYOpgH+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790785678; c=relaxed/simple;
	bh=lF2OhdUpNqPj3w+0W1ypKdrl6F3iNIvljxdIws9sOLY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qkP+D3ZgVqbEOrq5t4R0CYLNLrae4FNMCIgZwcKbd+lF1jZALHmXMJXgAIJtekHghLSVIiv5rnowbi/MRceR9yjoht0NDXp97/uTD3gUG4eerxQuwKirLCFjznwzF59+z1xdlGd90cq5Iz/KcuM7jExSRwII0Y7nRXwaD+as6Pg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TkUMH958; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TkUMH958"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 912031F00898;
	Wed, 30 Sep 2026 16:27:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790785671;
	bh=Vc9++yir5bdvCOYLml7csvyJmMpLQOdq+5fhkWl1/V0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TkUMH958+ABU25sfLTuNZZYoIKdbRyfRJDDHpTfvtAZKzK3PP3JOxvk5x8pOYcpTq
	 WUO+cKMcD/FxQJAGQTCd+hQSZjiRGBTcyS37f12jnVnEht3vk/DELlzBCQEqbrk+O7
	 Ka4Vc+8tSWAbv1jJ69UE05OQgY9Y2A9vuRTcL2kI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	TencentOS Corvus AI <corvus@tencent.com>,
	Aohan Mei <henrymei@tencent.com>,
	David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>
Subject: [PATCH 6.1 545/982] smb: client: reject userspace cifs.idmap descriptions
Date: Wed, 30 Sep 2026 17:21:21 +0200
Message-ID: <20260930152428.477645848@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -96,8 +96,23 @@ cifs_idmap_key_destroy(struct key *key)
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


