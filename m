Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9C0A3F23DB;
	Fri,  4 Sep 2026 05:18:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499084; cv=none; b=b+cn7Bd40025siU6TQJ2zEF61xOFtzKnDY8g7Ducip9t4BJAr9F81jFF11/J9mSBhVguHbwsB3gi8yTNu1vvhXfyolS8B2AKxbxgDm99t0Yz78hHcrtKB4e6Yvt+p0h05wSc/jlm/JhIyqsGuFqusC1iveip44sy4oej7wxNBLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499084; c=relaxed/simple;
	bh=4EuTuqXhPpMay3GxtwncGtZ8JzLNVV/kI44hwuoFmow=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m5eqzNHfOcsYhk7L8GCamvkj6PeMJQxIQRSRrsJbg5G6OtlEVH6xSbq6FB+hK629NOS2mr63+CL03/SyK2JeSUlp0S1dBuIMNxmCgkMUXgjkpCf337xfkXOLu6V4Uv9RJceYEuCr2mVRb9j4fVd1RBVEyahW8DF/4DvO6glk12M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yAQ0pgb/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yAQ0pgb/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16ACD1F00A3D;
	Fri,  4 Sep 2026 05:18:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499083;
	bh=fkGMX6SKQLrn4WVfu+rJaHWsSZhBC5N+u2q+Eoep+1A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yAQ0pgb/J1fEtH6AfjRilK4nOqrbZB4IB+NQwPjXE1pcTYon7DTnAadx6SFocvTxo
	 AgQdvwZtxOgV+byP7ZGwa0mQMAo37qfJdSY7t6kq8BLXCraWKvJgjFjNwAM5IR89A7
	 T2y2zUEp1vQM+zQl9IfUgYEsW511yZwiFLddayCo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robert Morris <rtm@csail.mit.edu>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 7.2 265/713] ntfs: reject invalid empty mapping pairs
Date: Fri,  4 Sep 2026 06:53:53 +0200
Message-ID: <20260904045809.777096174@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hyunchul Lee <hyc.lee@gmail.com>

commit 766062a82e1ce4087c7dc077224144dfd34b3661 upstream.

Reject an attribute with empty mapping pairs if it has inconsistent
highest VCN and size.

Fixes: 11ccc9107dc4 ("ntfs: update runlist handling and cluster allocator")
Reported-by: Robert Morris <rtm@csail.mit.edu>
Closes: https://lore.kernel.org/all/9519.1786907182@localhost/
Cc: stable@vger.kernel.org
Signed-off-by: Hyunchul Lee <hyc.lee@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ntfs/runlist.c |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

--- a/fs/ntfs/runlist.c
+++ b/fs/ntfs/runlist.c
@@ -772,6 +772,25 @@ struct runlist_element *ntfs_mapping_pai
 		return ERR_PTR(-EIO);
 	}
 
+	/*
+	 * An empty mapping-pairs array is valid only for a zero-length
+	 * attribute.
+	 */
+	if (!*buf &&
+	    (vcn ||
+	     le64_to_cpu(attr->data.non_resident.highest_vcn) !=
+		     (u64)(vcn - 1) ||
+	     le64_to_cpu(attr->data.non_resident.allocated_size) ||
+	     le64_to_cpu(attr->data.non_resident.data_size) ||
+	     le64_to_cpu(attr->data.non_resident.initialized_size))) {
+		ntfs_error(vol->sb, "Invalid empty mapping pairs array.");
+		return ERR_PTR(-EIO);
+	}
+	if (!vcn && !*buf && old_runlist && old_runlist->rl) {
+		*new_rl_count = old_runlist->count;
+		return old_runlist->rl;
+	}
+
 	/* Current position in runlist array. */
 	rlpos = 0;
 	/* Allocate first page and set current runlist size to one page. */


