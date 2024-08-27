Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A06CC1BC073;
	Tue, 27 Aug 2024 15:23:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772237; cv=none; b=S/kmF69tflsKmJG8PoPvamsxGbI0HKMrgX5GdIsKGJV7sZ9MIaCA81ugEx9nfi+e5PXtGSSKpudGStQtKkpUfgygcqn7p5Nq2hMHtpf2u6DN3Y6/JPqWVvPVKeMpguqu438HFM/IEoboaWdKbMmqqbsy407oVcJZG42oh1MgQOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772237; c=relaxed/simple;
	bh=NpIXwWfO3vTOMhKP07i5uJz/kib9KeVx8tKhpwWkkDI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SwbFSXcPUh03VsXGmpUC3zDrpvcJ/1BD0P+4AxCvdvE//KOsY/q9sGM0hfGCH+ivmijprgP42Yv6iiDtv46MJ4On83MfUjP31ayFdlk+6mOvNw+8/1i+4rAyyNVaQ1cLYiza9i1O/PibDkdCCaU2qdKra8GiL86E7gGX5jfyfAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VbeWisLO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VbeWisLO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E074C61062;
	Tue, 27 Aug 2024 15:23:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772237;
	bh=NpIXwWfO3vTOMhKP07i5uJz/kib9KeVx8tKhpwWkkDI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VbeWisLO0ZZMTy50gACRdQ3e3E7kVtHV6dKQpKJ/kcz053/FBAhTWq+Vbcjikwi0Z
	 Gwh4sSrr+1WOdYAdF1ow9okvznMYSXGoNj2HCcOqE1xbR7h5AJIwjkxPd6nt64JLjb
	 w0WtMDoZQ812ukxA2Smwtpv1EHJucSPOBd5qfc28=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jim Cromie <jim.cromie@gmail.com>,
	Jean Delvare <jdelvare@suse.com>,
	Guenter Roeck <linux@roeck-us.net>,
	linux-hwmon@vger.kernel.org,
	Kees Cook <keescook@chromium.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 154/321] hwmon: (pc87360) Bounds check data->innr usage
Date: Tue, 27 Aug 2024 16:37:42 +0200
Message-ID: <20240827143844.095930313@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kees Cook <keescook@chromium.org>

[ Upstream commit 4265eb062a7303e537ab3792ade31f424c3c5189 ]

Without visibility into the initializers for data->innr, GCC suspects
using it as an index could walk off the end of the various 14-element
arrays in data. Perform an explicit clamp to the array size. Silences
the following warning with GCC 12+:

../drivers/hwmon/pc87360.c: In function 'pc87360_update_device':
../drivers/hwmon/pc87360.c:341:49: warning: writing 1 byte into a region of size 0 [-Wstringop-overflow=]
  341 |                                 data->in_max[i] = pc87360_read_value(data,
      |                                 ~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~
  342 |                                                   LD_IN, i,
      |                                                   ~~~~~~~~~
  343 |                                                   PC87365_REG_IN_MAX);
      |                                                   ~~~~~~~~~~~~~~~~~~~
../drivers/hwmon/pc87360.c:209:12: note: at offset 255 into destination object 'in_max' of size 14
  209 |         u8 in_max[14];          /* Register value */
      |            ^~~~~~

Cc: Jim Cromie <jim.cromie@gmail.com>
Cc: Jean Delvare <jdelvare@suse.com>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: linux-hwmon@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Link: https://lore.kernel.org/r/20231130200207.work.679-kees@kernel.org
[groeck: Added comment into code clarifying context]
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/pc87360.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/hwmon/pc87360.c b/drivers/hwmon/pc87360.c
index a4adc8bd531ff..534a6072036c9 100644
--- a/drivers/hwmon/pc87360.c
+++ b/drivers/hwmon/pc87360.c
@@ -323,7 +323,11 @@ static struct pc87360_data *pc87360_update_device(struct device *dev)
 		}
 
 		/* Voltages */
-		for (i = 0; i < data->innr; i++) {
+		/*
+		 * The min() below does not have any practical meaning and is
+		 * only needed to silence a warning observed with gcc 12+.
+		 */
+		for (i = 0; i < min(data->innr, ARRAY_SIZE(data->in)); i++) {
 			data->in_status[i] = pc87360_read_value(data, LD_IN, i,
 					     PC87365_REG_IN_STATUS);
 			/* Clear bits */
-- 
2.43.0



