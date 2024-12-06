Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B307C1494D9;
	Fri,  6 Dec 2024 14:40:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496046; cv=none; b=u/0qtpEXxnDEsUJMb3BW3BVGGT99xizCkwMfYpbDpw4Yaz4c11646F7IiU8DUNdOm0cUs0vSNmTvm2dT2csbdwVTGS5fDqZ74ag2koTgdprfK5ESaoR4HtQsPCOMu7FsDqv4erjfhUGDzuCEzuytcudGItDnG7qEztaeocoudcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496046; c=relaxed/simple;
	bh=UXdzxMEuuu1Mx/Ea37pfszdcx+0APprI9AUdApQgFKo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jl6Dc6Lt4wwuS2SFH1Anwc3Jn0zD+r55RdTecJL9sV8PSJISKkg+/ajzCa9WvRN+GgQVYff411vG3zHUl9Bv6l9irXoxce4v73Ng7eDF2HLQO0efdx+Stg6UQuz0tLkQe8SbPZ4Bs2rD/Wv8AnotaKoQQkg09TxvMgEZOyVVR4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vDyIPMZY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vDyIPMZY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 207ABC4CEDC;
	Fri,  6 Dec 2024 14:40:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496046;
	bh=UXdzxMEuuu1Mx/Ea37pfszdcx+0APprI9AUdApQgFKo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vDyIPMZY8XuN1QxECtZ5ZTCTvyVucyG2iVpZ9C1BuZSSbksut0f37h5sVHc0Swvhm
	 zvYNuDq42DHTReTb325c9rD4GybZn4h4g0AEU2q6TlsRNu1ZXu3bEfQ794hWEkApcI
	 JieZVwf4QknSuS3mWN+Y8ptiO+z7+TxDmpPSV7vI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.12 035/146] media: gspca: ov534-ov772x: Fix off-by-one error in set_frame_rate()
Date: Fri,  6 Dec 2024 15:36:06 +0100
Message-ID: <20241206143529.015843723@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143527.654980698@linuxfoundation.org>
References: <20241206143527.654980698@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jinjie Ruan <ruanjinjie@huawei.com>

commit d2842dec577900031826dc44e9bf0c66416d7173 upstream.

In set_frame_rate(), select a rate in rate_0 or rate_1 by checking
sd->frame_rate >= r->fps in a loop, but the loop condition terminates when
the index reaches zero, which fails to check the last elememt in rate_0 or
rate_1.

Check for >= 0 so that the last one in rate_0 or rate_1 is also checked.

Fixes: 189d92af707e ("V4L/DVB (13422): gspca - ov534: ov772x changes from Richard Kaswy.")
Cc: stable@vger.kernel.org
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/usb/gspca/ov534.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/usb/gspca/ov534.c
+++ b/drivers/media/usb/gspca/ov534.c
@@ -847,7 +847,7 @@ static void set_frame_rate(struct gspca_
 		r = rate_1;
 		i = ARRAY_SIZE(rate_1);
 	}
-	while (--i > 0) {
+	while (--i >= 0) {
 		if (sd->frame_rate >= r->fps)
 			break;
 		r++;


