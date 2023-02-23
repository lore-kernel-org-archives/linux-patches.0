Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFB48257C
	for <patches@lists.linux.dev>; Thu, 23 Feb 2023 13:09:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36A69C433EF;
	Thu, 23 Feb 2023 13:09:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1677157753;
	bh=L4upDBkMmALa/cWsFSeaYL6ZAig1trAUOlx9Jmo8zdY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l3wn0rZOM37Jf6RJ/NIxL24m1XtvGdgHtjiiaR2czqCJ+H6VkxpWbyL377KDBvozo
	 wvufwHusdhdZGEuttra1vl/4ILvXRRGQdO9eQ37/6L6RUu9ETDVdeB8pk8rsJtjL8j
	 96N/tsCN3JkKzM3WtcrDlap9bWbuQ9IV6XXrZlvk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Zhang <yu.c.zhang@linux.intel.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 25/46] selftests: kvm: move declaration at the beginning of main()
Date: Thu, 23 Feb 2023 14:06:32 +0100
Message-Id: <20230223130432.738580951@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230223130431.553657459@linuxfoundation.org>
References: <20230223130431.553657459@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Paolo Bonzini <pbonzini@redhat.com>

[ Upstream commit 50aa870ba2f7735f556e52d15f61cd0f359c4c0b ]

Placing a declaration of evt_reset is pedantically invalid
according to the C standard.  While GCC does not really care
and only warns with -Wpedantic, clang ignores the declaration
altogether with an error:

x86_64/xen_shinfo_test.c:965:2: error: expected expression
        struct kvm_xen_hvm_attr evt_reset = {
        ^
x86_64/xen_shinfo_test.c:969:38: error: use of undeclared identifier evt_reset
        vm_ioctl(vm, KVM_XEN_HVM_SET_ATTR, &evt_reset);
                                            ^

Reported-by: Yu Zhang <yu.c.zhang@linux.intel.com>
Reported-by: Sean Christopherson <seanjc@google.com>
Fixes: a79b53aaaab5 ("KVM: x86: fix deadlock for KVM_XEN_EVTCHN_RESET", 2022-12-28)
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c b/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
index 8383457e66990..0668ec542cccd 100644
--- a/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
+++ b/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
@@ -428,6 +428,7 @@ static void *juggle_shinfo_state(void *arg)
 int main(int argc, char *argv[])
 {
 	struct timespec min_ts, max_ts, vm_ts;
+	struct kvm_xen_hvm_attr evt_reset;
 	struct kvm_vm *vm;
 	pthread_t thread;
 	bool verbose;
@@ -942,10 +943,8 @@ int main(int argc, char *argv[])
 	}
 
  done:
-	struct kvm_xen_hvm_attr evt_reset = {
-		.type = KVM_XEN_ATTR_TYPE_EVTCHN,
-		.u.evtchn.flags = KVM_XEN_EVTCHN_RESET,
-	};
+	evt_reset.type = KVM_XEN_ATTR_TYPE_EVTCHN;
+	evt_reset.u.evtchn.flags = KVM_XEN_EVTCHN_RESET;
 	vm_ioctl(vm, KVM_XEN_HVM_SET_ATTR, &evt_reset);
 
 	alarm(0);
-- 
2.39.0



