Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623276;
	b=gs9V+YBXxJjM9gxF5tXcDmQFE3PmuoCHdn/NGUsRSRPtazuMgk801vmouD+CFKDdRrNl
	 IgvTqV7sbsZbzu8c/h9+bKmCHy1opZ51M/XK5fAgVJ9yAfctn4LsNil0hC0omzNsthMy5
	 3GktnICqsowOHZuoV70qDqjb0o7NEe3IaHVDx7NeRE1g4T4Vr7EHRni098X89tA/XcXW8
	 J0lvR78NPBIQR/WvL8kijEYVCYFOSX4u6mOr+4G24rMRHUEb656W93LNMc3bplyydbe0b
	 kcbgxqUws4j5e1SNXUH+FOve4x7tOgxM0nuIl1yk/Lwe25TP3gdQZeGWU6SagU9ivIg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623276;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KMNdL3EEcNdtM59+KY3/k+eNGxAgaL8rCh2ue4hpnNs=;
	b=BS5REQ1r//2MEs+lSDms0gJK4CWdELFTiET0q0PaNmYsGG/utFzASS70usfJVR61jgZO
	 JdjeHSBvPbtV09qLVF3MZUm50n031OVuNQxWS4GOYtbCNMEYPiOQdDPLqjHUddkbs6xa5
	 0ddwRRA4G9Iy9/PebKxTmfeaXZywkKCvwcUXAEYwumyHHLD3JkEyDpH5JDb44mWBEeGYW
	 7WBsnObqDH54qj3mSJm9UWUbg63nrsYGMhTdQhmzlBFkdkt3D6F/LlxayQInBNAFHZL7i
	 m/eFjn7akQrI09P0Yn/oKV9fzaRegVmW8JlKfKUa18tVPG8b6CIIvJi2jgHK8q1cTgg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hdP+MGY3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D884606A31E;
	Wed, 25 Nov 2026 16:14:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hdP+MGY3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD7961F000C6;
	Wed, 25 Nov 2026 16:14:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623275;
	bh=KMNdL3EEcNdtM59+KY3/k+eNGxAgaL8rCh2ue4hpnNs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hdP+MGY3fXT2KUElgvtv+bI2ecXhVQhXJH1+9ap5X5IDhOKWRtvqlKo38OgDCbwjB
	 wS+PhSQPfcChaFKLpvvmEuuhr8Yqy2V37azs18A+V1rQFLTB8F0QKukpwAjCoCBpkS
	 9g3D3wqlGgy6qR4jk+qy2shI+0qHNB/OE0HC6+2k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Subject: [PATCH 6.18 806/990] tracing/probes: Fix missing BTF kind checks in char pointer/array helpers
Date: Wed, 25 Nov 2026 15:36:13 +0100
Message-ID: <20261125143840.924263022@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Masami Hiramatsu (Google) <mhiramat@kernel.org>

commit c1e2c63e65421068566db3dde44dfd4fe7adb46d upstream.

In struct btf_type, the type ID and byte size share a union, and only
BTF_KIND_INT types are followed by a 32-bit integer encoding word.
Because btf_type_is_char_ptr() and btf_type_is_char_array() do not
verify that the outer type is BTF_KIND_PTR or that the resolved element
type is a non-NULL BTF_KIND_INT before inspecting it, non-pointer BTF
types can have their byte size misinterpreted as a BTF type ID, and
arrays of non-integer types read out-of-bounds or misinterpret trailing
BTF metadata as BTF_INT_* encoding bits.

Validate the BTF type kinds and NULL pointers before reading inner type
metadata in both helpers.

Link: https://lore.kernel.org/all/179455851632.403392.258264246782960594.stgit@devnote2/

Fixes: 27973e5c64b9 ("tracing/probes: Add string type check with BTF")
Cc: stable@vger.kernel.org
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_probe.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/kernel/trace/trace_probe.c
+++ b/kernel/trace/trace_probe.c
@@ -356,6 +356,9 @@ static bool btf_type_is_char_ptr(struct
 	const struct btf_type *real_type;
 	u32 intdata;
 
+	if (BTF_INFO_KIND(type->info) != BTF_KIND_PTR)
+		return false;
+
 	real_type = btf_type_skip_modifiers(btf, type->type, NULL);
 	if (!real_type)
 		return false;
@@ -380,6 +383,11 @@ static bool btf_type_is_char_array(struc
 	array = (const struct btf_array *)(type + 1);
 
 	real_type = btf_type_skip_modifiers(btf, array->type, NULL);
+	if (!real_type)
+		return false;
+
+	if (BTF_INFO_KIND(real_type->info) != BTF_KIND_INT)
+		return false;
 
 	intdata = btf_type_int(real_type);
 	return !(BTF_INT_ENCODING(intdata) & BTF_INT_SIGNED)


