Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFB0B143C4A;
	Wed, 19 Jun 2024 13:02:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802151; cv=none; b=uOgV4gro6uhw0q/xdhG67W8OcAljS359WvEKVON6aLcMRbFZVWSo7ErBCqUG2Aab/6cYvhbGTtl25ghYlwL3MkcZpbzv/qX57ueD8EV0fBje8OdCzEmCbZHjkaVv8lWC5vdLnZiBKogJ9Xs/tJaqaejbf/yiWkhfaKal06wxirs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802151; c=relaxed/simple;
	bh=+p0aFEuBFRJulEkt5EV+/YPaTElybed/oYtvan29vcc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sSw7gBnrArDPNQLEwQ9RiUTvpCGpdyI+FX+UuAqGP5RUsfKrPmQHu+dNetaT/AmZ8dPeHZ8MASP0zjuIVL8f+5dXLjwpsML2zS1/mD0A0SoK46IETasmQGTiO9TsbSlt73DOUo0v/WeEPAlhB5y67Kx2OoYVD8DBM2epj7tvuxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xzWt3map; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xzWt3map"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37D90C2BBFC;
	Wed, 19 Jun 2024 13:02:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802151;
	bh=+p0aFEuBFRJulEkt5EV+/YPaTElybed/oYtvan29vcc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xzWt3mapw1RtgxT5mgjSEh5O9LwJ0q9BvEtd2DGcIFs0FU+edtg5wJYMdDjeAI9xS
	 1h3Nwx3TUy+32sY0mOJvLPSstzI+Ip74gMrjXsZq+SYoLuRHjDJebSYpf8kL+Lm7Nu
	 xQVYtkzC+tZJGM2eOFsgo+ic2HHJlcISNPcb0CV4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ni <nichen@iscas.ac.cn>,
	Rahul Rameshbabu <rrameshbabu@nvidia.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 100/267] HID: nvidia-shield: Add missing check for input_ff_create_memless
Date: Wed, 19 Jun 2024 14:54:11 +0200
Message-ID: <20240619125610.191730670@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125606.345939659@linuxfoundation.org>
References: <20240619125606.345939659@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen Ni <nichen@iscas.ac.cn>

[ Upstream commit 0a3f9f7fc59feb8a91a2793b8b60977895c72365 ]

Add check for the return value of input_ff_create_memless() and return
the error if it fails in order to catch the error.

Fixes: 09308562d4af ("HID: nvidia-shield: Initial driver implementation with Thunderstrike support")
Signed-off-by: Chen Ni <nichen@iscas.ac.cn>
Reviewed-by: Rahul Rameshbabu <rrameshbabu@nvidia.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-nvidia-shield.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/hid-nvidia-shield.c b/drivers/hid/hid-nvidia-shield.c
index edd0b0f1193bd..97dfa3694ff04 100644
--- a/drivers/hid/hid-nvidia-shield.c
+++ b/drivers/hid/hid-nvidia-shield.c
@@ -283,7 +283,9 @@ static struct input_dev *shield_haptics_create(
 		return haptics;
 
 	input_set_capability(haptics, EV_FF, FF_RUMBLE);
-	input_ff_create_memless(haptics, NULL, play_effect);
+	ret = input_ff_create_memless(haptics, NULL, play_effect);
+	if (ret)
+		goto err;
 
 	ret = input_register_device(haptics);
 	if (ret)
-- 
2.43.0



