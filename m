Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B63BF79C0
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 18:53:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B797C433C1;
	Wed, 30 Nov 2022 18:53:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669834383;
	bh=QRMQNKU5WrmXKfWnnUxMxBy3de40RPScvOym+3sJIEs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NdCh0CPa56JMDzBgaSU4Nav3CXmZPPX8bFrraoBCxicTZrUPDG3jh6Vop4i1FNfUa
	 vR1fCyRctOjpGiq4TpWGHgSjwWJ4HauL+91Hwb0Oj+XlSov04yhgfpCOFkLyUlArbX
	 ckZKM3IAZxe8oB+igwwau8x7wraYl9q2iqzdbzEg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kevin Tian <kevin.tian@intel.com>,
	Sean Christopherson <seanjc@google.com>,
	Zhenyu Wang <zhenyuw@linux.intel.com>
Subject: [PATCH 6.0 206/289] drm/i915/gvt: Get reference to KVM iff attachment to VM is successful
Date: Wed, 30 Nov 2022 19:23:11 +0100
Message-Id: <20221130180548.790451779@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Sean Christopherson <seanjc@google.com>

commit 9ed1fdee9ee324f3505ff066287ee53143caaaa2 upstream.

Get a reference to KVM if and only if a vGPU is successfully attached to
the VM to avoid leaking a reference if there's no available vGPU.  On
open_device() failure, vfio_device_open() doesn't invoke close_device().

Fixes: 421cfe6596f6 ("vfio: remove VFIO_GROUP_NOTIFY_SET_KVM")
Cc: stable@vger.kernel.org
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Zhenyu Wang <zhenyuw@linux.intel.com>
Link: http://patchwork.freedesktop.org/patch/msgid/20221111002225.2418386-2-seanjc@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/gvt/kvmgt.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/gpu/drm/i915/gvt/kvmgt.c
+++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
@@ -765,8 +765,6 @@ static int intel_vgpu_open_device(struct
 		return -ESRCH;
 	}
 
-	kvm_get_kvm(vgpu->vfio_device.kvm);
-
 	if (__kvmgt_vgpu_exist(vgpu))
 		return -EEXIST;
 
@@ -777,6 +775,7 @@ static int intel_vgpu_open_device(struct
 
 	vgpu->track_node.track_write = kvmgt_page_track_write;
 	vgpu->track_node.track_flush_slot = kvmgt_page_track_flush_slot;
+	kvm_get_kvm(vgpu->vfio_device.kvm);
 	kvm_page_track_register_notifier(vgpu->vfio_device.kvm,
 					 &vgpu->track_node);
 


