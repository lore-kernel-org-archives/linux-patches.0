Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B0AF223E77;
	Thu, 12 Dec 2024 17:43:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734025431; cv=none; b=Vla5h5EBeCh4kCdcp2n6qf0Olf4WXooV2LdFkDA0XfnHJ1LeZrc5enQCOy1IeynENBvkYzF9DtmQ8Ni3Hnyt7aajuPBJViagqjrH2AG0Hw6jJKUscXXdR/qqNecreSrBO0+SxhID3zsTI1Mnjr20FIIIbA32lLTUDBTHxK7kR7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734025431; c=relaxed/simple;
	bh=eq2E/Vps1O0CL0pyDU54obhV6Z3Z4gUreU3y+oJiUs8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AlSRIQT3Jq6ZHzjCzygL/uY/iy5PTJtXaTuc9+bO93jY0YNCTkLk2cugnH1WVRRk2H5GbO40tkcIHGN0sEi4uibWiPTWLm/PNcuDFjC9koggyQUI+FlLG9k6a9NisoW/CvO0WfWUAC06+UPxjKJvHOmV5xWZ6Oc/l6AH/2ScecQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MmYEUjy+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MmYEUjy+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D124C4CECE;
	Thu, 12 Dec 2024 17:43:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734025431;
	bh=eq2E/Vps1O0CL0pyDU54obhV6Z3Z4gUreU3y+oJiUs8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MmYEUjy+4VncxmzmUDJ0zMv3k6ny3IpZvuH3mLWwFGk84JagacY/Z1K9Owf3q54YX
	 wKQlUnSMddLQaeHWDA9tVNA3S1A2Y/hQYsd2044QNM2Tf84qs8yJdcwUyGdo8/qT+c
	 Fah+YHA/8Ci8a/7VvLdFdx9JC0FEM4f3ylEQJfz0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Gerecke <jason.gerecke@wacom.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 5.4 167/321] HID: wacom: Interpret tilt data from Intuos Pro BT as signed values
Date: Thu, 12 Dec 2024 16:01:25 +0100
Message-ID: <20241212144236.574564357@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144229.291682835@linuxfoundation.org>
References: <20241212144229.291682835@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Gerecke <jason.gerecke@wacom.com>

commit 49a397ad24ee5e2c53a59dada2780d7e71bd3f77 upstream.

The tilt data contained in the Bluetooth packets of an Intuos Pro are
supposed to be interpreted as signed values. Simply casting the values
to type `char` is not guaranteed to work since it is implementation-
defined whether it is signed or unsigned. At least one user has noticed
the data being reported incorrectly on their system. To ensure that the
data is interpreted properly, we specifically cast to `signed char`
instead.

Link: https://github.com/linuxwacom/input-wacom/issues/445
Fixes: 4922cd26f03c ("HID: wacom: Support 2nd-gen Intuos Pro's Bluetooth classic interface")
CC: stable@vger.kernel.org # 4.11+
Signed-off-by: Jason Gerecke <jason.gerecke@wacom.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/wacom_wac.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/hid/wacom_wac.c
+++ b/drivers/hid/wacom_wac.c
@@ -1394,9 +1394,9 @@ static void wacom_intuos_pro2_bt_pen(str
 					rotation -= 1800;
 
 				input_report_abs(pen_input, ABS_TILT_X,
-						 (char)frame[7]);
+						 (signed char)frame[7]);
 				input_report_abs(pen_input, ABS_TILT_Y,
-						 (char)frame[8]);
+						 (signed char)frame[8]);
 				input_report_abs(pen_input, ABS_Z, rotation);
 				input_report_abs(pen_input, ABS_WHEEL,
 						 get_unaligned_le16(&frame[11]));


