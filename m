Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 523E941A554;
	Sat, 12 Sep 2026 11:17:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789211841; cv=none; b=DTE70qKVRMMxrKZlagoanmtkxi9xA3zoQjgSLJMvtg+3YVRsCJ+suHrvMkjiP0DglLCoPm2S3eWRmCb4KvfR2KM592UFCaZ/joiQWV+5nf9gEhYJ3uU58Yw0phbL+of4CDqPhXOlc0vUt5T4RH9j4ZHGwAJeNIye8hTb+5Eioo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789211841; c=relaxed/simple;
	bh=HL19gW+29jEbcdlh85GbcVIrY82z/EV6Dl7ZwKXl/Ug=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=loCGyUHL2Zf7PIzVZ0FS3EN8RDEebaLWeIhNvfmm1k/1ULts35NphsDGoHhFjFkq01GN4x76EKNtMqdJcebl/R+cIsRNyXPwJyTzkYUhVvSmzyHsqw7+yvRV/8yEzg7hzuWxzfxu20a2TjeVOx+PiJIbg44MOO0Qfnp4pk2Wr8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NsHHxuKt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NsHHxuKt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 966811F000FF;
	Sat, 12 Sep 2026 11:17:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789211840;
	bh=Eow34Vv6RSjzzJ3JclC6UwyUsTd70qPNd5lVIav6unc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NsHHxuKtA4UJgw9Gf5niUxMCMJ+wL1emxXs8wIiRUHiAabTVmsEIXZABnPq5TOXZd
	 60mi9ngMInYd3poT307RPShrrTIQFqYwQ6cfJIPzJrTl6aJU0UsEhN1yCX3chp1JZ1
	 bfFmYMq0bn9PV7FfGG1FoNVKDeEi37EQAPlSrlGs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hemanth Selam <hemanth.selam@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1287/1518] platform/x86/amd/hsmp: Reject negative power cap writes in hwmon
Date: Sat, 12 Sep 2026 08:57:36 +0200
Message-ID: <20260912065652.627730574@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hemanth Selam <hemanth.selam@gmail.com>

[ Upstream commit 3921bb8635ff2836622df1cdf3194d4f3c1835a4 ]

hsmp_hwmon_write() takes the user-supplied hwmon value as a signed long
and assigns "val / MICROWATT_PER_MILLIWATT" to msg.args[0], which is a
__u32.  MICROWATT_PER_MILLIWATT is an unsigned long, so a negative write
to power1_cap (e.g. "echo -1 > power1_cap") is first converted to a huge
unsigned value by the division and then stored into the u32 argument.

As a result a nonsensical, multi-gigawatt socket power limit is sent to
the SMU via HSMP_SET_SOCKET_POWER_LIMIT instead of the write being
rejected.

Reject negative values with -EINVAL before the conversion.

Tested with HSMP enabled:

  CAP=$(dirname $(grep -l amd_hsmp_hwmon \
        /sys/class/hwmon/hwmon*/name | head -1))/power1_cap

  # negative write
  echo -1000000 > $CAP ; echo "ret=$?"
  # valid positive write must still work
  echo 400000000 > $CAP ; echo "ret=$?"

Before:
  # echo -1000000 > $CAP ; echo "ret=$?"
  ret=0                             <- accepted; bogus limit sent to SMU
  # echo 400000000 > $CAP ; echo "ret=$?"
  ret=0

After:
  # echo -1000000 > $CAP ; echo "ret=$?"
  bash: echo: write error: Invalid argument
  ret=1                             <- rejected with -EINVAL
  # echo 400000000 > $CAP ; echo "ret=$?"
  ret=0                             <- valid write still works

Fixes: 92c025db52bb ("platform/x86/amd/hsmp: Report power via hwmon sensors")
Signed-off-by: Hemanth Selam <hemanth.selam@gmail.com>
Link: https://patch.msgid.link/20260812090012.140193-1-hemanth.selam@gmail.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/amd/hsmp/hwmon.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/platform/x86/amd/hsmp/hwmon.c b/drivers/platform/x86/amd/hsmp/hwmon.c
index 0cc9a742497fc..c8314eee06f4f 100644
--- a/drivers/platform/x86/amd/hsmp/hwmon.c
+++ b/drivers/platform/x86/amd/hsmp/hwmon.c
@@ -31,6 +31,9 @@ static int hsmp_hwmon_write(struct device *dev, enum hwmon_sensor_types type,
 	if (attr != hwmon_power_cap)
 		return -EOPNOTSUPP;
 
+	if (val < 0)
+		return -EINVAL;
+
 	msg.num_args = 1;
 	msg.args[0] = val / MICROWATT_PER_MILLIWATT;
 	msg.msg_id = HSMP_SET_SOCKET_POWER_LIMIT;
-- 
2.53.0



