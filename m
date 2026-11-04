Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829131;
	b=Rgoea7j45JmgmCy52HsKMmFqibu0EFTBYkkoIO607B3TGPsQhl9a0GcAcCIS+bvIki3/
	 VzsnDRL1v3ZWFZ080zjfc2bOzITyYYXXo1SUI019OK1reF78z7sDI26GOwL3/0tGKL3SX
	 +R4aLvbX+lTD4Qykbx6zPGDVCck12Hri6KEOvCL2mokOevQ/7pZfya5hMC2IE5lASc1YP
	 eTOf13MnJJUjuSLULttTfreX+rjhUonuvxdc9LkYfD/5BKjSN+iwddAUZMWvucHFRo3dR
	 I7INxELgxl2N5ZEDnzof8RZfdWMqobDoERr05a5qkSdMNdBKQ590sQsbhEHXG8NSfYw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829131;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mau3CLExpV4JMNzOIHN8AQNLsGkVGuLlVnRj7/ULmWk=;
	b=vhFeIXGz3vhh4vNROsF2Wv385BkAswVKA4CWpJIoA3ptjKtsqxbZVCZSw4yZYaZZDYrF
	 1PxZ8BZqqc55QuIEqeTTXTj3wVP7Y5yzXNV7FrKlvaZxacPPQ+XyDi8mysRlB2MOGEYtF
	 iVb7Uk/LUTnlWBYbBk/QQK74QweQ0uypJ9rzf0x2YS0ueMaFBKNfV9DykCV8oltxH1g02
	 NsiT7AfKpuVk1G7Vb5pnEtlIaNgl0168DPWeHxT2ureJsPQgdUgNox9FUxfLo2LUanjau
	 +6cRrtQHEsur+WO5UT1JZ0/F1DWU13eLSU6ufGCFX02ephGilTRDX49lE77pKsALBlg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qw8qgQ2u;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29F66607350D;
	Wed,  4 Nov 2026 21:52:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qw8qgQ2u
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEAC91F00919;
	Wed,  4 Nov 2026 21:52:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829131;
	bh=mau3CLExpV4JMNzOIHN8AQNLsGkVGuLlVnRj7/ULmWk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qw8qgQ2uc1xMimEF10S5AikgD5bQDkDSqU5fAlPcOCiS7yaPLy05XV4u01hS+SD7q
	 3C4mBHDlAcpzzRduHq8UpV16OJQc09ayw6D2OvfvSBir4ShP46bUVVGdHn8t9FNwai
	 7rnfPlgX9ppKjXQGwFgcUvas9ba5D/OxTnkWGVCY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	David Woodhouse <dwmw@amazon.co.uk>,
	Paul Durrant <paul@xen.org>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 7.3 465/547] KVM: x86/xen: Enforce 4-byte alignment of vcpu_info registration
Date: Wed,  4 Nov 2026 16:10:49 -0500
Message-ID: <20261104211051.565461144@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Woodhouse <dwmw@amazon.co.uk>

commit eacdb76c5f04956035c5d7f7e1973028f30684a2 upstream.

Xen's map_guest_area() enforces that vcpu_info is aligned to
sizeof(xen_ulong_t). KVM has no such check, allowing a guest to
register vcpu_info at an arbitrary byte alignment.

Enforce unconditional 4-byte alignment regardless of the current
shinfo mode. This is sufficient because subsequent commits ensure
that all locked atomic operations on vcpu_info fields use at most
32-bit accesses. Return -ENXIO on failure, matching Xen's
map_guest_area() behaviour for unaligned requests.

Originally observed in review of an unrelated patch:
https://lore.kernel.org/all/20260604193554.1BA311F00893@smtp.kernel.org/

Cc: stable@vger.kernel.org
Fixes: 73e69a86347a ("KVM: x86/xen: register vcpu info")
Reported-by: sashiko-bot@kernel.org
Closes: https://lore.kernel.org/all/20260604193554.1BA311F00893@smtp.kernel.org
Assisted-by: Kiro:claude-opus-4.6-1m
Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
Reviewed-by: Paul Durrant <paul@xen.org>
Link: https://patch.msgid.link/20260831213632.81023-7-dwmw2@infradead.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/xen.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -941,6 +941,10 @@ int kvm_xen_vcpu_set_attr(struct kvm_vcp
 				break;
 			}
 
+			r = -ENXIO;
+			if (!IS_ALIGNED(data->u.gpa, sizeof(u32)))
+				break;
+
 			r = kvm_gpc_activate(&vcpu->arch.xen.vcpu_info_cache,
 					     data->u.gpa, sizeof(struct vcpu_info));
 		} else {
@@ -950,6 +954,10 @@ int kvm_xen_vcpu_set_attr(struct kvm_vcp
 				break;
 			}
 
+			r = -ENXIO;
+			if (!IS_ALIGNED(data->u.hva, sizeof(u32)))
+				break;
+
 			r = kvm_gpc_activate_hva(&vcpu->arch.xen.vcpu_info_cache,
 						 data->u.hva, sizeof(struct vcpu_info));
 		}


