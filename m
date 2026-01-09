Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 051F0359F8E;
	Fri,  9 Jan 2026 12:49:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962998; cv=none; b=qyRTFu0rApz6JDXeJAXhVvDdTSp7LmehpFJOJnV2J1IWSL/fAqC0bc8c1RTWWZFPihPFWVXZzRq+tHte07ts3t3SExJS0YNe0d/mhGy6Ta65g8216Y9bWgmB5upMmx2VUhgWvoumsjmnjW4/3mabxoYgOAMzUpEp53AwqG9XSsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962998; c=relaxed/simple;
	bh=p0C/GEoEQ6vUJbbjUQMSqyu/za+HPl/3+PPLte63Iac=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EEL4hoi/XYf/geSYSOnXgj2jGVVDk5WU/XfsGThWCm7tWHMw3sziNIdUTP38IIFKFjfNY2VkKnrc0Ts3Ij5Z1knW6wRiXVS8KCVMq+MnZc8qZCUMtjvKCLGBRgDcE157+D/DArROkTQvvDtH6CiFIHEfiapevUeOroogrT9q2bk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tgh+ydy9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tgh+ydy9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 877BBC4CEF1;
	Fri,  9 Jan 2026 12:49:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962997;
	bh=p0C/GEoEQ6vUJbbjUQMSqyu/za+HPl/3+PPLte63Iac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Tgh+ydy9OhCArZ6tZTKAF5uo9LMbrX4chHlBnqXCArP2uX6WOe5AX/uYWP6d0ca5F
	 4wgy4VmVmMYiUjTq89sKQrbPswBi+w4CKUX+YahOlrpIAZN6wVumPi6QBJ7F9CsKIo
	 CsjQtLtvZQgl6KlMFeqzsUurhKi/B1KcNmA8QEvw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Norbert Szetei <norbert@doyensec.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Rajani Kantha <681739313@139.com>
Subject: [PATCH 6.1 529/634] ksmbd: fix out-of-bounds in parse_sec_desc()
Date: Fri,  9 Jan 2026 12:43:27 +0100
Message-ID: <20260109112137.472791216@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

From: Namjae Jeon <linkinjeon@kernel.org>

commit d6e13e19063db24f94b690159d0633aaf72a0f03 upstream.

If osidoffset, gsidoffset and dacloffset could be greater than smb_ntsd
struct size. If it is smaller, It could cause slab-out-of-bounds.
And when validating sid, It need to check it included subauth array size.

Cc: stable@vger.kernel.org
Reported-by: Norbert Szetei <norbert@doyensec.com>
Tested-by: Norbert Szetei <norbert@doyensec.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Rajani Kantha <681739313@139.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/smbacl.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

--- a/fs/smb/server/smbacl.c
+++ b/fs/smb/server/smbacl.c
@@ -815,6 +815,13 @@ static int parse_sid(struct smb_sid *psi
 		return -EINVAL;
 	}
 
+	if (!psid->num_subauth)
+		return 0;
+
+	if (psid->num_subauth > SID_MAX_SUB_AUTHORITIES ||
+	    end_of_acl < (char *)psid + 8 + sizeof(__le32) * psid->num_subauth)
+		return -EINVAL;
+
 	return 0;
 }
 
@@ -856,6 +863,9 @@ int parse_sec_desc(struct user_namespace
 	pntsd->type = cpu_to_le16(DACL_PRESENT);
 
 	if (pntsd->osidoffset) {
+		if (le32_to_cpu(pntsd->osidoffset) < sizeof(struct smb_ntsd))
+			return -EINVAL;
+
 		rc = parse_sid(owner_sid_ptr, end_of_acl);
 		if (rc) {
 			pr_err("%s: Error %d parsing Owner SID\n", __func__, rc);
@@ -871,6 +881,9 @@ int parse_sec_desc(struct user_namespace
 	}
 
 	if (pntsd->gsidoffset) {
+		if (le32_to_cpu(pntsd->gsidoffset) < sizeof(struct smb_ntsd))
+			return -EINVAL;
+
 		rc = parse_sid(group_sid_ptr, end_of_acl);
 		if (rc) {
 			pr_err("%s: Error %d mapping Owner SID to gid\n",
@@ -892,6 +905,9 @@ int parse_sec_desc(struct user_namespace
 		pntsd->type |= cpu_to_le16(DACL_PROTECTED);
 
 	if (dacloffset) {
+		if (dacloffset < sizeof(struct smb_ntsd))
+			return -EINVAL;
+
 		parse_dacl(user_ns, dacl_ptr, end_of_acl,
 			   owner_sid_ptr, group_sid_ptr, fattr);
 	}


