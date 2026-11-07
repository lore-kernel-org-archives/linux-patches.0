Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063744;
	b=Wm3qn8A7hEFenfbEDCOqXRaKc/jRgLWxRUTy9qQTL79oagK/NctfjzVGHHJECCM+hBgc
	 lgvAy0SzUh1su3v7c++TI49tdyJLZ8FjcVO0+1J/3zUWWYRdlULe0zb59j3SFYHUSI246
	 Gb0rZUV+fTf03rWqlun0GkyHszpBJA3LA+KVt/T9AuUB4B3H/hkKL8vQ/O94JMf6/cFOW
	 3sb6E8NpNGFNcOY6Mwi3/K4QtnfDlgtjcVCBg8BM+/7IxYZBHE5KYW81C2FSlCYzsBl9T
	 3uQHVXsec7kDs9flCXBpq33BFe+w6UhLh+ng8XHSPykvoo4pupENZCTEvGWj/ifObhA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063744;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ppqVFicmgoe0f2Yab+ocoF6zxAChh+bhZ4bva2vXxJ8=;
	b=sETRLjEQq7KP/QutIuCAn25gkXUDijhySoNxSfJvvhsK7MJI98e1R1BrTOho4yPaN1zM
	 CjNCZv7c6L4P8SZVVWlLib6FUHY2QdSqxRi0DcRv0H1iopvuu9g1eGvqUqCrtEa45ZeCA
	 8eMIN4Q2JzCmUZkNUS7z3m1hFCkGJMjiWcoolsri2hu37Kp0gWkBSD9CMWlzIpEgoxm82
	 xX66AzyJ5ErjByFooBMTfG9keyc82W4pojelNmMsXnpJeeM7xyHmzdL37uPTeG9YrJ0P6
	 YC/YgqVv56xgpJdt2q9LyuWAQLnxIizFK2t6Mx53p7/rHEacJ1BeUGdCXr1JFLUr7zA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iJDmAwgo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEE03606A32D;
	Sat,  7 Nov 2026 15:02:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iJDmAwgo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CB0A1F0089F;
	Sat,  7 Nov 2026 15:02:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063743;
	bh=ppqVFicmgoe0f2Yab+ocoF6zxAChh+bhZ4bva2vXxJ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iJDmAwgoY4Uga6Sp6EpaJlq/DfwrEqHNdaCU1c98986Y9fS6fLNLQHVNAo2TxAntK
	 7831sExB23OVnjY3nnciNdkkYVe2tYwqnaifpDqVHk6vZgeqRBeP4BVOPxmZpkGFVm
	 RY2v6WVdDgVSGAbLJrVziWHIWJ8UEzBXfvBoG/u0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fang Xieyan <fangxy@xiaopeng.com>,
	Douglas Anderson <dianders@chromium.org>,
	Daniel Thompson <daniel@riscstar.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 838/869] kgdb: Fix buffer overflow in the m packet handler
Date: Sat,  7 Nov 2026 08:58:40 -0500
Message-ID: <20261107134921.292081997@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

From: Fang Xieyan <fangxy@xiaopeng.com>

[ Upstream commit ac0159129e2cb99a70c4b80cfbf58d03e092dc7b ]

gdb_cmd_memread() passes the length of the 'm' packet straight to
kgdb_mem2hex(), which hex-encodes the reply into
remcom_out_buffer[BUFMAX] without checking that the reply fits. A
client on the KGDB I/O console can ask for a read of any size, and
the hex encoding runs off the end of the buffer. kgdb_mem2hex() takes
that length as an int count, so 2^31 truncates to a negative value
and copy_from_kernel_nofault() is handed buf + count as its
destination.

On x86 BUFMAX is 1024, so a read of 512 bytes overruns by the single
byte that terminates the hex string:

  BUG: KASAN: global-out-of-bounds in kgdb_mem2hex+0x1dd/0x230
  Write of size 1 at addr ffffffff87651780 by task sh/1
  ...
  The buggy address belongs to the variable:
   remcom_out_buffer+0x400/0x420

Bounds check the length before the hex encoding:

		if (length > (BUFMAX - 1) / 2) {
			error_packet(remcom_out_buffer, -EINVAL);
			return;
		}

gdbstub_msg_write() already bounds the count it hex-encodes
against BUFMAX. Reads over the limit never returned valid data,
so an error reply loses nothing.

Fixes: dc7d55270521 ("kgdb: core")
Cc: stable@vger.kernel.org
Assisted-by: Hawkeye:GLM-5.3-flash
Assisted-by: Qoder:Qwen3.8-Max
Signed-off-by: Fang Xieyan <fangxy@xiaopeng.com>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Link: https://lore.kernel.org/r/20260914180344.15485-1-fangxy@xiaopeng.com
Signed-off-by: Daniel Thompson <daniel@riscstar.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/debug/gdbstub.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/kernel/debug/gdbstub.c b/kernel/debug/gdbstub.c
index 22fe969c5d2e5..75b9cf07ebbe0 100644
--- a/kernel/debug/gdbstub.c
+++ b/kernel/debug/gdbstub.c
@@ -562,6 +562,14 @@ static void gdb_cmd_memread(struct kgdb_state *ks)
 
 	if (kgdb_hex2long(&ptr, &addr) > 0 && *ptr++ == ',' &&
 					kgdb_hex2long(&ptr, &length) > 0) {
+		/*
+		 * The hex-encoded reply needs 2 * length + 1 bytes
+		 * in remcom_out_buffer[BUFMAX].
+		 */
+		if (length > (BUFMAX - 1) / 2) {
+			error_packet(remcom_out_buffer, -EINVAL);
+			return;
+		}
 		err = kgdb_mem2hex((char *)addr, remcom_out_buffer, length);
 		if (!err)
 			error_packet(remcom_out_buffer, -EINVAL);
-- 
2.53.0



