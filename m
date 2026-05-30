Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27FC834EF07;
	Sat, 30 May 2026 16:56:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780160191; cv=none; b=uXig4XHUAomjm9KW9yWx4n/wpnDtu1x5P6gKwLNznpE5HfUb9xRPuzYn9rsERtdus5CI7UzzJKW0plAvK1uGlUmK3Fe5ZzG6fG6bzil0ixOcWHjShh08Rt9yJYjwUkWe0mc83ZJIKhsuVMMB8mbklnNZJYxmBUxs7V9un6DJwFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780160191; c=relaxed/simple;
	bh=jb2M0GF/42xxRPQ6MvaRmm4UrOmQlaWLsFPCte6HnbU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V6UeHqML8TaC336CHPyJZhN5/G7IFAZQfrwYDnz/sxoge1ry7s5SDXRHLbiy1CJ439/F9p86KK1yu4kFVqctWzUbWHXx75IDs3X4+pCck2r1iP/sr7A9puJoY6EQjzSkmXnvr+wdUvCc/xRbWYoJ8ESrx6KVr/uv6Sdt1COQCgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YS1EJ9SR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YS1EJ9SR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6526E1F00893;
	Sat, 30 May 2026 16:56:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780160190;
	bh=ZpF3VX+83bh3pA4VCHtK9tbn3OWAZYSESXld2H6ogwY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YS1EJ9SRraDwrzTWWR2Vk5mddHhzH6hMOZvkhlhmut5//NPCwJOIOvnMCxbFIqfeU
	 tw8mbuIIPpWylI3n2hvPxUJbcjW0ZEXYeRWo9WP5LBHxkmHV3E51N68z5UioY6hAdk
	 OKhO3c9Ml5YGv7o9WmN04WJMAgi8nMR7UzxPJyqs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.1 232/969] KVM: nSVM: Mark all of vmcb02 dirty when restoring nested state
Date: Sat, 30 May 2026 17:55:56 +0200
Message-ID: <20260530160306.864547009@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

From: Yosry Ahmed <yosry.ahmed@linux.dev>

commit e63fb1379f4b9300a44739964e69549bebbcdca4 upstream.

When restoring a vCPU in guest mode, any state restored before
KVM_SET_NESTED_STATE (e.g. KVM_SET_SREGS) will mark the corresponding
dirty bits in vmcb01, as it is the active VMCB before switching to
vmcb02 in svm_set_nested_state().

Hence, mark all fields in vmcb02 dirty in svm_set_nested_state() to
capture any previously restored fields.

Fixes: cc440cdad5b7 ("KVM: nSVM: implement KVM_GET_NESTED_STATE and KVM_SET_NESTED_STATE")
CC: stable@vger.kernel.org
Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
Link: https://patch.msgid.link/20260210010806.3204289-1-yosry.ahmed@linux.dev
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/nested.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -1661,6 +1661,12 @@ static int svm_set_nested_state(struct k
 	nested_vmcb02_prepare_control(svm, svm->vmcb->save.rip, svm->vmcb->save.cs.base);
 
 	/*
+	 * Any previously restored state (e.g. KVM_SET_SREGS) would mark fields
+	 * dirty in vmcb01 instead of vmcb02, so mark all of vmcb02 dirty here.
+	 */
+	vmcb_mark_all_dirty(svm->vmcb);
+
+	/*
 	 * While the nested guest CR3 is already checked and set by
 	 * KVM_SET_SREGS, it was set when nested state was yet loaded,
 	 * thus MMU might not be initialized correctly.


