Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED40D2C032C;
	Sat, 12 Sep 2026 09:12:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789204357; cv=none; b=kLeV2NFvERsOEgINlzdzdxuBQQxRcNh2eRD9xHEjUCIqZfpjooDhSUT1YpA8uMdAuwB5dNJQzUFI+ldTdG9gE+vGBIJ09ZkQjU8IbhxLQ12KIN5+0GORtwEhhAhXWnw4abrKN11BbMu+1B4G03U63+4f/Zc1ax2/P/H/eYTygUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789204357; c=relaxed/simple;
	bh=PqR3dH6ipz0kc9w6Bj3m8b/tJnK2Y4chFO8IyO/g9a0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sJW1Eu1H8+j/suxqZ1ETwRrQNqz/1zYR2hLpTrNyhbwidQwGKt9oMzMgoNHROxGxArNAV4sSLzIhEF3MGRqsBp49dKo8u5BOT9JNo8TKi4FAMpjoxdOhIRqUuGX7QX/nLIG5JeMcpbwcGYgCM3B56NlSBLyDylnhLgV+wjgm8FY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R9N8xcor; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R9N8xcor"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD8171F000FF;
	Sat, 12 Sep 2026 09:12:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789204355;
	bh=MpAl+JC00MODxI3Qu3hcqmPooCgljvxZa6RURjvhfkk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R9N8xcorT7XAq4kdSDSypozbPy5f+DiI7O5u2Ofd871WcnrShexblZMerdUD7MbEP
	 RfVRXBZ2hC/dQZSyZv4PVahzi6SmePZ5INNhfgWlRaj9qAp1krdfUnw1gDJBW/Dd/+
	 MUx5lVGcbDTbdiFwOowJhkPyfL6ROkcYNNwpxl5w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hemanth Selam <hemanth.selam@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1594/1815] platform/x86/amd/hsmp: Reject negative power cap writes in hwmon
Date: Sat, 12 Sep 2026 08:55:44 +0200
Message-ID: <20260912065726.411214661@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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



