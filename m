Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17C4648C8CB;
	Sat, 12 Sep 2026 18:32:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789237932; cv=none; b=O512phAiPoAiHG7L+ppWDovZ8cSPwJnwRSTetV1LBnhGcSpBd6e4RRuI9A1peQMSBH/CL8MCPyVCMCTPJirI66AZ47ARXFGI1cXayzAOhVr849tUKX9Qz/bOb0dER6WZ4BdkT6L2I7Ex5Eh80BKLoJL6nw3cOdZqL/WP3ck/zGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789237932; c=relaxed/simple;
	bh=64fVmuukyNVtS0YNjkXqy8sIYBMug104NBoi2BRcULM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eDeujXggcBr37wlSn9Lrq9Cw+P7oy8z86FAdDt/aSs5/l6jZHV2ZYfGG48VYBVH43/Yf4bvexEjHVSVpEOtCdvQI8Yt5BPP7joG2lres8PJkxlpX7cubUqvwnmO8bN6ZUqToFdk6W9M2dSdWseNmjbBqVaQKXWWfVmhhFw7Fddg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QHeJb29O; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QHeJb29O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD37B1F000FF;
	Sat, 12 Sep 2026 18:32:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789237927;
	bh=aOFv3ZZZpjvBW7qcl0EKcvGjYKyk4cLJqsNaJR0kDPs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QHeJb29OiBJYqfLKWLdtHK0RbOO06M651xTInTT6/BlFXB8Yd3AfRyTGQobjemtfW
	 7X8GcwMlypcoYz/btAVU/FhQULs5v0xQZhqOttowTOM0h4f0iKQ6ByDyS9kVYyzjso
	 d0aIEqig9npco8enxZ6JY3RQBom7E54dQnwPNcuI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>
Subject: [PATCH 5.15 304/935] KVM: s390: Fix old_data leak in guest debug error path
Date: Sat, 12 Sep 2026 08:55:34 +0200
Message-ID: <20260912065533.782308372@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Borntraeger <borntraeger@linux.ibm.com>

commit aa9c8e8baf1e765fa65b93212522c636f25d846f upstream.

__import_wp_info() allocates a per-watchpoint old_data buffer to back up
the original guest memory contents. If a later watchpoint of the same
KVM_SET_GUEST_DEBUG request fails to import, kvm_s390_import_bp_data()
jumps to the error label, which frees the wp_info array but not the
old_data buffers of the entries that were imported successfully. Up to
MAX_BP_COUNT - 1 buffers of up to MAX_WP_SIZE bytes are leaked per failed
request, and the request can be repeated.

Create error handling for cleaning up all created old_data memory
areas.

Fixes: 27291e2165b6 ("KVM: s390: hardware support for guest debugging")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Message-ID: <20260805110455.7200-6-borntraeger@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/kvm/guestdbg.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/arch/s390/kvm/guestdbg.c
+++ b/arch/s390/kvm/guestdbg.c
@@ -256,7 +256,7 @@ int kvm_s390_import_bp_data(struct kvm_v
 			ret = __import_wp_info(vcpu, &bp_data[i],
 					       &wp_info[nr_wp]);
 			if (ret)
-				goto error;
+				goto error_wp;
 			nr_wp++;
 			break;
 		case KVM_HW_BP:
@@ -273,6 +273,10 @@ int kvm_s390_import_bp_data(struct kvm_v
 	vcpu->arch.guestdbg.hw_wp_info = wp_info;
 	kfree(bp_data);
 	return 0;
+
+error_wp:
+	while (nr_wp--)
+		kfree(wp_info[nr_wp].old_data);
 error:
 	kfree(bp_data);
 	kfree(wp_info);


