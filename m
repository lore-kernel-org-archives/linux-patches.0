Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D8F31F93D
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 16:09:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7ADE6C433C8;
	Fri, 21 Jul 2023 16:09:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689955753;
	bh=n94Biq5/c+0fazZagLDYClaomg/kp/vXLlTlA+oR9KM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wOSHHuSPg3sFlSLjZ/eNRKtB9L8zZq4j8TXIyqmnDgnRWL6F27qqdBdu/1nfCVCs6
	 +KQf619ubLk1XPbtludYIh1Y7Z3yMevXqKdzKetYtL+PhltK2sFGwyCYLiEPLdR0dk
	 47jnDMDF+WP4T1Y+wBmFUk7puT2iB7dzjZiXDfSY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kai-Heng Feng <kai.heng.feng@canonical.com>,
	Basavaraj Natikar <Basavaraj.Natikar@amd.com>,
	Akshata MukundShetty <akshata.mukundshetty@amd.com>,
	Benjamin Tissoires <bentiss@kernel.org>
Subject: [PATCH 6.4 005/292] HID: amd_sfh: Fix for shift-out-of-bounds
Date: Fri, 21 Jul 2023 18:01:54 +0200
Message-ID: <20230721160529.044623693@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160528.800311148@linuxfoundation.org>
References: <20230721160528.800311148@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Basavaraj Natikar <Basavaraj.Natikar@amd.com>

commit 87854366176403438d01f368b09de3ec2234e0f5 upstream.

Shift operation of 'exp' and 'shift' variables exceeds the maximum number
of shift values in the u32 range leading to UBSAN shift-out-of-bounds.

...
[    6.120512] UBSAN: shift-out-of-bounds in drivers/hid/amd-sfh-hid/sfh1_1/amd_sfh_desc.c:149:50
[    6.120598] shift exponent 104 is too large for 64-bit type 'long unsigned int'
[    6.120659] CPU: 4 PID: 96 Comm: kworker/4:1 Not tainted 6.4.0amd_1-next-20230519-dirty #10
[    6.120665] Hardware name: AMD Birman-PHX/Birman-PHX, BIOS SFH_with_HPD_SEN.FD 04/05/2023
[    6.120667] Workqueue: events amd_sfh_work_buffer [amd_sfh]
[    6.120687] Call Trace:
[    6.120690]  <TASK>
[    6.120694]  dump_stack_lvl+0x48/0x70
[    6.120704]  dump_stack+0x10/0x20
[    6.120707]  ubsan_epilogue+0x9/0x40
[    6.120716]  __ubsan_handle_shift_out_of_bounds+0x10f/0x170
[    6.120720]  ? psi_group_change+0x25f/0x4b0
[    6.120729]  float_to_int.cold+0x18/0xba [amd_sfh]
[    6.120739]  get_input_rep+0x57/0x340 [amd_sfh]
[    6.120748]  ? __schedule+0xba7/0x1b60
[    6.120756]  ? __pfx_get_input_rep+0x10/0x10 [amd_sfh]
[    6.120764]  amd_sfh_work_buffer+0x91/0x180 [amd_sfh]
[    6.120772]  process_one_work+0x229/0x430
[    6.120780]  worker_thread+0x4a/0x3c0
[    6.120784]  ? __pfx_worker_thread+0x10/0x10
[    6.120788]  kthread+0xf7/0x130
[    6.120792]  ? __pfx_kthread+0x10/0x10
[    6.120795]  ret_from_fork+0x29/0x50
[    6.120804]  </TASK>
...

Fix this by adding the condition to validate shift ranges.

Fixes: 93ce5e0231d7 ("HID: amd_sfh: Implement SFH1.1 functionality")
Cc: stable@vger.kernel.org
Tested-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Signed-off-by: Basavaraj Natikar <Basavaraj.Natikar@amd.com>
Signed-off-by: Akshata MukundShetty <akshata.mukundshetty@amd.com>
Link: https://lore.kernel.org/r/20230707065722.9036-3-Basavaraj.Natikar@amd.com
Signed-off-by: Benjamin Tissoires <bentiss@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/amd-sfh-hid/sfh1_1/amd_sfh_desc.c |   20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

--- a/drivers/hid/amd-sfh-hid/sfh1_1/amd_sfh_desc.c
+++ b/drivers/hid/amd-sfh-hid/sfh1_1/amd_sfh_desc.c
@@ -143,16 +143,32 @@ static int float_to_int(u32 flt32_val)
 	if (!exp && !mantissa)
 		return 0;
 
+	/*
+	 * Calculate the exponent and fraction part of floating
+	 * point representation.
+	 */
 	exp -= 127;
 	if (exp < 0) {
 		exp = -exp;
+		if (exp >= BITS_PER_TYPE(u32))
+			return 0;
 		zeropre = (((BIT(23) + mantissa) * 100) >> 23) >> exp;
 		return zeropre >= 50 ? sign : 0;
 	}
 
 	shift = 23 - exp;
-	flt32_val = BIT(exp) + (mantissa >> shift);
-	fraction = mantissa & GENMASK(shift - 1, 0);
+	if (abs(shift) >= BITS_PER_TYPE(u32))
+		return 0;
+
+	if (shift < 0) {
+		shift = -shift;
+		flt32_val = BIT(exp) + (mantissa << shift);
+		shift = 0;
+	} else {
+		flt32_val = BIT(exp) + (mantissa >> shift);
+	}
+
+	fraction = (shift == 0) ? 0 : mantissa & GENMASK(shift - 1, 0);
 
 	return (((fraction * 100) >> shift) >= 50) ? sign * (flt32_val + 1) : sign * flt32_val;
 }


