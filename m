Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9568304BCB;
	Sat, 30 May 2026 17:50:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780163439; cv=none; b=SgKUwb2roOEwiBz7lNHObXT01YvOVzjOLxM7CrZpS+IFJrgDc//jaYRERKS68gLPYVLYwk8ARGdIk7r46UKE4ktT+bMk2a1r+NpmamkKYsUSZdSvgdPuf6q7VpBcN31Kru041KCCCVJ8UosvYTH6+c4s2IkA/tSPs+oM9DBN7HI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780163439; c=relaxed/simple;
	bh=OxcREV+eJT8GN116/OJintm51C7+Od+e+IFRAjItCRQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XyYiYTH7fbW78WKBboOi1Vb8hQHtxGTJBmPcVJdNuAcdhgFD+lTgPt8TnckswnpO3+mLWcyVB2bEtuoRFCoERMbwpgOXRCj2L21geiAYrEyUDUl39RTADktqSMZCpcO4B+SSQrt6fmWWvAGIYF3KuF2GaTd+0MS+qWhnai77P8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bF+hw599; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bF+hw599"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFAD61F00893;
	Sat, 30 May 2026 17:50:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780163438;
	bh=DIRs5W/LkJvnThBpCIJQsYSoo8JpGVerOABRsYSUxOs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bF+hw599z05fwrCSZHoG0pBXaBDnu8nigswePgmu0MlrXJe8x5qfsyeHxr3IipQ2b
	 xUaP/Di0qQxMnlw0XzrVdJF+pmQzQiuSIlEcKXJHzYC3bMaksu3sKvT7v/QrTkZV4J
	 yRVJFS/bX4Y8WBNjBTJQP+cNyE1VPglIbevq6Qkg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 5.15 231/776] KVM: nSVM: Mark all of vmcb02 dirty when restoring nested state
Date: Sat, 30 May 2026 17:59:05 +0200
Message-ID: <20260530160246.498970789@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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
@@ -1387,6 +1387,12 @@ static int svm_set_nested_state(struct k
 	nested_vmcb02_prepare_control(svm);
 
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


