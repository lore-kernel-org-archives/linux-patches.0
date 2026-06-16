Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A435C38837F;
	Tue, 16 Jun 2026 15:34:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781624089; cv=none; b=Q6nkhiMj+45W8e7Qn2N4EVYVI6NENE4F80yiJr2+EnUAfsOwKcmwvtVB/VreeLJ4qnxG14HGYyTyZb+Z2rN0MN64D7bPKgyCuVHMalsGunLbjL4nl+EQkaDgWVG/Hz/PMy0rN+0FPchQEBrWBZXcTfoL05U63HmhDlFasXArkRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781624089; c=relaxed/simple;
	bh=cCdAZMIKUMlW1ix9zLlEsS3wVBREFO9v9NB/rsQ6QOs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BX2I9PQjsvlvCUItv4Y5H2I9kL3k5Ax1xkE3vKejc1+8IuRHeDILQ86NMe83Cq7qIwdMangJkY/StYiS/cM7KlPCnO2flGy7VqUVKezk4IoSoS6ZJPR7nKQXS0wT/31eFZLyjnMoSeNmYQjM2unVaLSw7w7z8ow1r7zF7hDJZ8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L4IaxAAS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L4IaxAAS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A803A1F000E9;
	Tue, 16 Jun 2026 15:34:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781624088;
	bh=j6SwvOeDSVeEvXeiVWgZI5lXqFE0kGluyRkr42RIdqA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L4IaxAASCOCs9E7c1bzzWXJ+cinPJFUwfZ4HzUPl8+yI8YaxHViK/DcIWcLgEXx95
	 GYro/d83JhcoApdLWlwow2jUcXb8muv+UilCiGXWQY7Z+hCeIWQ97LUv+lfS7lLyfv
	 8xJ/9WGjW9SLxffNXjegLOzF4VdSQfslSbqKdUFU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Bilal <meatuni001@gmail.com>,
	"Rob Herring (Arm)" <robh@kernel.org>
Subject: [PATCH 7.0 264/378] accel/ethosu: reject NPU_OP_RESIZE commands from userspace
Date: Tue, 16 Jun 2026 20:28:15 +0530
Message-ID: <20260616145123.986261786@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Muhammad Bilal <meatuni001@gmail.com>

commit ef911805d86a05363d3ec2fa9835a41def83bb7e upstream.

NPU_OP_RESIZE is a U85-only command that the driver does not yet
implement. The existing WARN_ON(1) placeholder fires unconditionally
whenever userspace submits this command via DRM_IOCTL_ETHOSU_GEM_CREATE,
causing unbounded kernel log spam.

If panic_on_warn is set the kernel panics, giving any unprivileged user
with access to the DRM device a trivial denial-of-service primitive.

Replace the WARN_ON(1) with an explicit -EINVAL return so the ioctl
rejects the command before it reaches hardware.

Fixes: 5a5e9c0228e6 ("accel: Add Arm Ethos-U NPU driver")
Cc: stable@vger.kernel.org
Signed-off-by: Muhammad Bilal <meatuni001@gmail.com>
Link: https://patch.msgid.link/20260523210840.92039-2-meatuni001@gmail.com
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/accel/ethosu/ethosu_gem.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/accel/ethosu/ethosu_gem.c
+++ b/drivers/accel/ethosu/ethosu_gem.c
@@ -449,8 +449,7 @@ static int ethosu_gem_cmdstream_copy_and
 				return ret;
 			break;
 		case NPU_OP_RESIZE: // U85 only
-			WARN_ON(1); // TODO
-			break;
+			return -EINVAL;
 		case NPU_SET_KERNEL_WIDTH_M1:
 			st.ifm.width = param;
 			break;


