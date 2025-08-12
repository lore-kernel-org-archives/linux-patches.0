Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F02312FDC32;
	Tue, 12 Aug 2025 17:39:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755020368; cv=none; b=rU3MvtQ5mGjQBRx9EQGjvowUjtqXv5hpqOJn/TPgSsM+ichMmK6B2TdoOT73VWda/68OJVpNujYqhcfRjeMgk88eWGFVN8F0hmv4f+B08b/0kHc5otNIbAhvIFsJsmh9giOVs9IRe89AOVGo5KJp/GV5jCNCGz56Ga+bb0Sbdyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755020368; c=relaxed/simple;
	bh=s0KOFgOb9eNtAL5CKVbfXZli2fYic9cwzkV5SjaO1fI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I54lJN4CM2VO+05nr91g9Xg5Ex3OkL71F4V3/XM3P8jK1xWvyNgHbSQIko9VXulhyFR5qOpTNhzBtfRwesjWXsdGOLKjU5ICt+3cM7vZ2b9jY/+R88GLSI3Par2ZutgST55KyBi20tf8DSPYF/y1NIy5JD473EQTzysfkkKAq+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U69PYBWd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U69PYBWd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 300EEC4CEF0;
	Tue, 12 Aug 2025 17:39:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755020367;
	bh=s0KOFgOb9eNtAL5CKVbfXZli2fYic9cwzkV5SjaO1fI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U69PYBWdp+9lZpRKFPIbzloKT/uR+oZ6BXB0NgAMAhK6FLKINoJjLnH6LWtgiqeQZ
	 p1U8KY0SD7BtnTSy8w99G6jIgPMc48LW/F53B9LENHAhd+lw/mupXnQ47dWp37Fqgc
	 YaSDA8SomRL7hsgA2FIYEshC09lcxIcB6qIwCqbc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Xiwen <forbidden405@outlook.com>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 6.1 027/253] i2c: qup: jump out of the loop in case of timeout
Date: Tue, 12 Aug 2025 19:26:55 +0200
Message-ID: <20250812172949.886047043@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172948.675299901@linuxfoundation.org>
References: <20250812172948.675299901@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Yang Xiwen <forbidden405@outlook.com>

commit a7982a14b3012527a9583d12525cd0dc9f8d8934 upstream.

Original logic only sets the return value but doesn't jump out of the
loop if the bus is kept active by a client. This is not expected. A
malicious or buggy i2c client can hang the kernel in this case and
should be avoided. This is observed during a long time test with a
PCA953x GPIO extender.

Fix it by changing the logic to not only sets the return value, but also
jumps out of the loop and return to the caller with -ETIMEDOUT.

Fixes: fbfab1ab0658 ("i2c: qup: reorganization of driver code to remove polling for qup v1")
Signed-off-by: Yang Xiwen <forbidden405@outlook.com>
Cc: <stable@vger.kernel.org> # v4.17+
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Link: https://lore.kernel.org/r/20250616-qca-i2c-v1-1-2a8d37ee0a30@outlook.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-qup.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/i2c/busses/i2c-qup.c
+++ b/drivers/i2c/busses/i2c-qup.c
@@ -452,8 +452,10 @@ static int qup_i2c_bus_active(struct qup
 		if (!(status & I2C_STATUS_BUS_ACTIVE))
 			break;
 
-		if (time_after(jiffies, timeout))
+		if (time_after(jiffies, timeout)) {
 			ret = -ETIMEDOUT;
+			break;
+		}
 
 		usleep_range(len, len * 2);
 	}


