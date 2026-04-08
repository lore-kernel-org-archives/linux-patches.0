Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 602DD3D411F;
	Wed,  8 Apr 2026 18:26:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775672783; cv=none; b=a6g3IAEBJIUdzITjcDW8JAGSkMNCcl4SiatId36t4l/T11uGP4lAFJxsOqd8l0t4t5m/SE+qxzVTRLlSrnEOrnweNoehjyGnxVBHco7P5RZy4y9X9xRKvyVS9xGm5Dc50VyY0gkE1AtuP//gIvhtyintK7kaPcDQGe+nqa1vPHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775672783; c=relaxed/simple;
	bh=QW8eyjumPUWKY6m70eGwzBTuGeZ+iBmBJNQzgDbcYEs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=St7ATvfb34nNMqQZOq07PuazlN87Dad8TirbdouUeXsjwwycxvFzn9fxkXoBeLLeSOskW3oIKACXKNOMnK2ZnIkzZx/JAU4tFyvKu1e7hmkyZZd6FDDkYQNnTyCnTIYJahow71wjbryZOz5/Oqg6AH2P9p5jFgsXCtY5YkS8Jeg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v7GFvYec; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v7GFvYec"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA40CC19421;
	Wed,  8 Apr 2026 18:26:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775672783;
	bh=QW8eyjumPUWKY6m70eGwzBTuGeZ+iBmBJNQzgDbcYEs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v7GFvYecGEAddG1Pyys/cvUuDrZ1ocPIlQDct9qqL/WMfG3QKzhBp01lQ157YfIrv
	 QWNhnPJNaISrQoZEWfsMKgQ6bCc+P8Oi6vUGXo+m3nTkDJVeoGkchb+R+9EjP3vrN+
	 Lldk9FmOZ8FVr/FHHhmZhxlIcDqVRnSBXu86NRY8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 6.6 133/160] thunderbolt: Fix property read in nhi_wake_supported()
Date: Wed,  8 Apr 2026 20:03:40 +0200
Message-ID: <20260408175918.158231735@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175913.177092714@linuxfoundation.org>
References: <20260408175913.177092714@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

commit 73a505dc48144ec72e25874e2b2a72487b02d3bc upstream.

device_property_read_foo() returns 0 on success and only then modifies
'val'. Currently, val is left uninitialized if the aforementioned
function returns non-zero, making nhi_wake_supported() return true
almost always (random != 0) if the property is not present in device
firmware.

Invert the check to make it make sense.

Fixes: 3cdb9446a117 ("thunderbolt: Add support for Intel Ice Lake")
Cc: stable@vger.kernel.org
Signed-off-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thunderbolt/nhi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/thunderbolt/nhi.c
+++ b/drivers/thunderbolt/nhi.c
@@ -1010,7 +1010,7 @@ static bool nhi_wake_supported(struct pc
 	 * If power rails are sustainable for wakeup from S4 this
 	 * property is set by the BIOS.
 	 */
-	if (device_property_read_u8(&pdev->dev, "WAKE_SUPPORTED", &val))
+	if (!device_property_read_u8(&pdev->dev, "WAKE_SUPPORTED", &val))
 		return !!val;
 
 	return true;


