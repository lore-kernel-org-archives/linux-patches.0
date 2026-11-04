Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829127;
	b=AuTmU2wboMfS3V43SA+TQLjkXztzOxzF9qNE43e6uXxFVWd4LCB/dAC4vdgCuGKSjAM1
	 MG8/m1rZ6SZgDYOr/Z7uG9n3o7/5wI14D3CBXxyyaLGU4VL91TOAGJbbBQUB8JkrSS23U
	 OjuNN/6K9bEV/RwA84j1Bt3cqky8bAyfxiWUvoCpY/835VwGMsph0K3MjiOsi1TI5YSy6
	 J0mZe71pJPaGjOgvaJxUiBwkmBG9OAap3bEuYu8dzSZA2OrVG51ozJVNuDTqlR96o7xwG
	 AJwGtlg/mCTJmrRLAEYGmYUu0sEJ85uzbX4OsJVUgcpz3iKeK3vh9Q1EC/d6x8scHxg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829127;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mKnFrbcFmMnhHa8ypbg9E7Rp/A7oeZsYUGH8ppdb8CA=;
	b=A4fjPR4m7YZlyFXYiq5CFHjo6BvR32LrA+NxRScmOJohcu5kWmIxZU+LnmTIKF3VFEsx
	 WKTBE5Ds/3NRZH/BM3xc3bfhA69AK7Lh2+Blo3JNGyDgAUFA1sB54lBkrMM5IjQq6dxa7
	 a5Dv8UCrJ8+RsXkJmw4mfHWZIPe7jrkL7xXTidOHXcy/mMpUZYn7xSdsXQnceZDoUcB/i
	 CMJ2xGfckhfHVL8R8Cfjqz0tj48kOtdpb5b1ZqzHBWiMdI9gIkGUtxdECrBKvoWtFd2nT
	 JSXrVpURszfm+wHRLKcB+FYIAgSUDtdqAtrwx1ZZIA/P7gG/iOyfiuPz6O+vhGzlChw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CXYAYXsW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C55B1607350D;
	Wed,  4 Nov 2026 21:52:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CXYAYXsW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F6771F000C1;
	Wed,  4 Nov 2026 21:52:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829126;
	bh=mKnFrbcFmMnhHa8ypbg9E7Rp/A7oeZsYUGH8ppdb8CA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CXYAYXsWJvu35su76PA4MPVhlZqORnQ1JI0nUQI3a4Ae9nPzDue6AiKdBXDNu4tBQ
	 QO/3efQeilz0l/+d03NSJ+q4nJhWaNPof6/mQYTcJnEx5awJvaldXjsdZOSI7eaZYJ
	 x8ExT8Jen6K8A1O2Z29qKhWkh4Jg0e2PVYQPIRCw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Xiaoyao Li <xiaoyao.li@intel.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 7.3 462/547] KVM: VMX: Preserve negative return value in vmx_handle_exit() with bus lock detected
Date: Wed,  4 Nov 2026 16:10:46 -0500
Message-ID: <20261104211051.477523309@linuxfoundation.org>
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

From: Xiaoyao Li <xiaoyao.li@intel.com>

commit cef48693da1e964e9f192bfc16cd0ed287c48337 upstream.

Preserve the negative return value from __vmx_handle_exit() when a bus
lock is detected, instead of always overwriting it with 0.

The purpose of bus_lock_detected handling is to force a userspace exit to
inform userspace that a bus lock happened. The negative return value can
achieve this purpose, and changing the negative value to 0 fails to return
an error to userspace. So, preserve the negative return value.

Fixes: fe6b6bc802b4 ("KVM: VMX: Enable bus lock VM exit")
Cc: stable@vger.kernel.org
Reported-by: sashiko-bot@kernel.org
Closes: https://lore.kernel.org/all/20260805034602.5B2BB1F000E9@smtp.kernel.org/
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Link: https://patch.msgid.link/20260819094903.3060020-7-xiaoyao.li@intel.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/vmx/vmx.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6864,11 +6864,12 @@ int vmx_handle_exit(struct kvm_vcpu *vcp
 	 * a bus lock in guest.
 	 */
 	if (vmx_get_exit_reason(vcpu).bus_lock_detected) {
-		if (ret > 0)
+		if (ret > 0) {
 			vcpu->run->exit_reason = KVM_EXIT_X86_BUS_LOCK;
+			ret = 0;
+		}
 
 		vcpu->run->flags |= KVM_RUN_X86_BUS_LOCK;
-		return 0;
 	}
 	return ret;
 }


