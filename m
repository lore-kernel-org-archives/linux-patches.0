Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8306B3254A9;
	Sun,  7 Jun 2026 10:37:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780828665; cv=none; b=c0ZcuJrZtv8HWHFlowlcxpsnTJ7VWzNIEyRpKaRWhAnXzwbJe0w6JQdTq+2Jj2QFBSQ+T2XtTG/yu/RgUz7Wk1fkHU2gS5+phVEDspX3jGx5kGvRQh1g70lkYtkHqBcZe++nk9AHi1hab0FsN/btsZBD01sR9SWNVTcd+Vg7FLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780828665; c=relaxed/simple;
	bh=jBhQt/o3ctMPY/7Z1FBxKhuabeXlyM5XQc9tlpkSLNU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s88BWABULFaa1vCPw1qXLwb2ChDDywb38KnU0iCaQbWM8X4HEu5bln46NUwzH2SoFBpnj9ZUjdYHMVaKNiRd2tUA6gNCDRf13iOFz5yv7es7jqx23AJ3MigJo0t7LsAJb8cR9jM5IKaifbe0t5MBtHkOKIUivO7gFZvNBxX+x/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OkWT9LtR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OkWT9LtR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8B5F1F00893;
	Sun,  7 Jun 2026 10:37:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780828664;
	bh=peshYLbFyqUgd2ouW9mMDohPFF10+jsYQGq0cImIXZ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OkWT9LtR3HHDkP5KUqTnojhX+kK0FBQw1MFPYJqR1oGe+r/U9D6k345uDXjv7RDnr
	 yDr3ZA+8l1ZpADoq/53WCev8m6IkwqtWZRsdGJrwBkC/Vv/5W6M1xBooe4MPk3ITsx
	 D95fN3VVlfbJRMMhCbDQwZPeoOVHl1Gpw6UQ+KY4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Michael Roth <michael.roth@amd.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 6.12 156/307] KVM: SEV: WARN if KVM attempts to setup scratch area with min_len==0
Date: Sun,  7 Jun 2026 11:59:13 +0200
Message-ID: <20260607095733.452454191@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.647295505@linuxfoundation.org>
References: <20260607095727.647295505@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

commit f185e05dce6f170f83c4ba602e969b1c3c7a22e6 upstream.

Now that all paths in KVM properly validate the length needed for the
scratch area, and are guaranteed to pass in a non-zero length, WARN if KVM
attempts to configured the scratch area with min_len==0 to guard against
future bugs.

Cc: stable@vger.kernel.org
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Reviewed-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-ID: <20260501202250.2115252-8-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/sev.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3509,6 +3509,9 @@ static int setup_vmgexit_scratch(struct
 	u64 scratch_gpa_beg, scratch_gpa_end;
 	void *scratch_va;
 
+	if (WARN_ON_ONCE(!min_len))
+		goto e_scratch;
+
 	scratch_gpa_beg = svm->sev_es.sw_scratch;
 	if (!scratch_gpa_beg) {
 		pr_err("vmgexit: scratch gpa not provided\n");


