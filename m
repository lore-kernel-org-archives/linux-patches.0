Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22766339BE;
	Fri, 24 Nov 2023 18:53:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MU0SxoEg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 535BAC433C7;
	Fri, 24 Nov 2023 18:53:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700851984;
	bh=Lf+lBjyyZUKJK+lLRNjayLHA58G+j+mpab8Nrz+CbXg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MU0SxoEgi2FjiTWiqh9PG8T9aW1BZvjYfbmFNmeWuBaiXdGTbAsVy9CVzYdVmgSbH
	 MxoPwGui0C4HZRHEFReigDatFE4y4nCYLIHmiphwUcOonkl78Hw/G8+tqBSj8AGjKU
	 31jzpQ2GrnLrjKFH6RyMBXVjWL1awtxIEzTdLafk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Saenz Julienne <nsaenz@amazon.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.1 174/372] KVM: x86: hyper-v: Dont auto-enable stimer on write from user-space
Date: Fri, 24 Nov 2023 17:49:21 +0000
Message-ID: <20231124172016.272335355@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172010.413667921@linuxfoundation.org>
References: <20231124172010.413667921@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Nicolas Saenz Julienne <nsaenz@amazon.com>

commit d6800af51c76b6dae20e6023bbdc9b3da3ab5121 upstream.

Don't apply the stimer's counter side effects when modifying its
value from user-space, as this may trigger spurious interrupts.

For example:
 - The stimer is configured in auto-enable mode.
 - The stimer's count is set and the timer enabled.
 - The stimer expires, an interrupt is injected.
 - The VM is live migrated.
 - The stimer config and count are deserialized, auto-enable is ON, the
   stimer is re-enabled.
 - The stimer expires right away, and injects an unwarranted interrupt.

Cc: stable@vger.kernel.org
Fixes: 1f4b34f825e8 ("kvm/x86: Hyper-V SynIC timers")
Signed-off-by: Nicolas Saenz Julienne <nsaenz@amazon.com>
Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Link: https://lore.kernel.org/r/20231017155101.40677-1-nsaenz@amazon.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/hyperv.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -705,10 +705,12 @@ static int stimer_set_count(struct kvm_v
 
 	stimer_cleanup(stimer);
 	stimer->count = count;
-	if (stimer->count == 0)
-		stimer->config.enable = 0;
-	else if (stimer->config.auto_enable)
-		stimer->config.enable = 1;
+	if (!host) {
+		if (stimer->count == 0)
+			stimer->config.enable = 0;
+		else if (stimer->config.auto_enable)
+			stimer->config.enable = 1;
+	}
 
 	if (stimer->config.enable)
 		stimer_mark_pending(stimer, false);


