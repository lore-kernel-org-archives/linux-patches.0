Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053715;
	b=0wVF8sIzLee+DB2TM7PFg7BFdZDM0omVYFVMT+3/w2Stl5Dq7iiZw04c7O9ZyMJmLqlV
	 uN33fUB4+ir+F4Nz4vx4h51jujYy7M0V47OmnGnWgMtfzjZi3xapvHKfxSLP8zkNjHbKO
	 SslTUdPODZDjRIqz5YMlkR/sSi+yRY9sk8Yk7zNevW0W6Ys6oFGFaHlVByh00ejc+4tHV
	 HToPG+uxFzuctjoHyjKrT27921S0z1imwZVPNQg2tbhtH8a0GC3xg+4vsK5+ejvN21vn0
	 vzJQ8PM5CcvHZAbQ4G2jdCeFC2Pyg54ySNIFI108aRCAIlrXmEIO8+ID6IitwIG9AUQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053715;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=9V8xztQt/d0FJEuS3Z8GtG8DtZwjgeKGE34PogV3mY0=;
	b=pBKarVdCX/a+NuISO52KNis0tz5IyFI3fkf5UNVYLUyBzvHUVHcpUSvPlUsKyEYuVOGS
	 XYNZQvxdw585YkKdg60cJGf/5dtP6R8mvlqnx6eP1rgIafZwb00hWFXRwH+WmrKDPkvIt
	 vdizTRPo1NWX1y4AAxLXYuQBqaHEVdksIarBICLjPVAAEYPAei3Tymtk2Sbhmk7o/956t
	 +eJV15D/J0sJeN4RcaG0pRjjvDyeufoQWAPJsQ8NhWXwh77IRI5GiNwyVAXoYJthjH5AI
	 mlAthUCNjpi7LOaFtpaSOFuvkLbRuXeqc9mtRIuu0+pxenPvvvJ7aWTdDzF8bF69Zkg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dTm9+RRr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 286EC606A31C;
	Thu, 19 Nov 2026 02:01:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dTm9+RRr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8030C1F000C4;
	Thu, 19 Nov 2026 02:01:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053715;
	bh=9V8xztQt/d0FJEuS3Z8GtG8DtZwjgeKGE34PogV3mY0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dTm9+RRrCk3zcN/LlRGYghnNaJev7Yh6xWRuFdKN6UR5eOAzOSKhqElBql+ZJlK+G
	 EW8ISWlvNDDaXxp/cvCkqBT76Fnz9MzMeVGFxW793wkJ08ZfkOUdvzkUGKZFtDTwq2
	 JIpTbAbvZdDcm1GLC+0pReF1vf/3GrBoRGwle79A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Bilal <meatuni001@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1016/2214] platform/x86: hp-wmi: fix heap OOB read and memory corruption in hp_wmi_perform_query()
Date: Wed, 18 Nov 2026 15:44:52 +0100
Message-ID: <20261118150053.017698053@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Muhammad Bilal <meatuni001@gmail.com>

[ Upstream commit 6dea092b261f04d632411c2be52d13190f5f67b1 ]

hp_wmi_perform_query() evaluates an ACPI WMI method and expects a
struct bios_return header in the returned buffer. However, it only
checks that the ACPI object type is ACPI_TYPE_BUFFER without verifying
that obj->buffer.length is at least sizeof(*bios_return) (8 bytes).

If the firmware or ACPI method returns a buffer shorter than 8 bytes:

1. bios_return->return_code at offset 4 reads out of bounds from the
   allocated ACPI buffer slab.

2. If return_code evaluates to 0 and outsize is non-zero,
   (int)(obj->buffer.length - sizeof(*bios_return)) evaluates to a
   negative integer (e.g. -8 for a 0-length buffer). actual_outsize is
   set to this negative value and passed to memcpy(buffer, ...,
   actual_outsize), where the signed negative value is cast to
   size_t (e.g. 0xfffffffffffffff8), attempting to copy ~18 Exabytes
   and triggering an immediate kernel crash. Additionally,
   memset(buffer + actual_outsize, ...) performs an out-of-bounds
   write before buffer.

Fix this by ensuring obj->buffer.length is at least sizeof(*bios_return)
before accessing the return code, and compute actual_outsize safely
using min_t(u32, ...), which is sound specifically because the guard
above already rules out obj->buffer.length being smaller than
sizeof(*bios_return) by the time that subtraction runs.

Fixes: c3021ea1beee ("hp-wmi: allow setting input and output buffer sizes separately")
Cc: stable@vger.kernel.org
Signed-off-by: Muhammad Bilal <meatuni001@gmail.com>
Link: https://patch.msgid.link/20260826103012.240453-1-meatuni001@gmail.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
[ sashal: Adjusted context for the missing pr_warn() line that upstream replaces. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/hp/hp-wmi.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/x86/hp/hp-wmi.c b/drivers/platform/x86/hp/hp-wmi.c
index 94c358f261411..b56e4121d238f 100644
--- a/drivers/platform/x86/hp/hp-wmi.c
+++ b/drivers/platform/x86/hp/hp-wmi.c
@@ -261,7 +261,9 @@ static int hp_wmi_perform_query(int query, enum hp_wmi_command command,
 	if (!obj)
 		return -EINVAL;
 
-	if (obj->type != ACPI_TYPE_BUFFER) {
+	if (obj->type != ACPI_TYPE_BUFFER ||
+	    obj->buffer.length < sizeof(*bios_return)) {
+		pr_warn("query 0x%x returned wrong type or too small buffer\n", query);
 		ret = -EINVAL;
 		goto out_free;
 	}
@@ -280,7 +282,7 @@ static int hp_wmi_perform_query(int query, enum hp_wmi_command command,
 	if (!outsize)
 		goto out_free;
 
-	actual_outsize = min(outsize, (int)(obj->buffer.length - sizeof(*bios_return)));
+	actual_outsize = min_t(u32, outsize, obj->buffer.length - sizeof(*bios_return));
 	memcpy(buffer, obj->buffer.pointer + sizeof(*bios_return), actual_outsize);
 	memset(buffer + actual_outsize, 0, outsize - actual_outsize);
 
-- 
2.53.0



