Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC35CD53B;
	Tue, 16 Jul 2024 15:35:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721144112; cv=none; b=YK2Ox8BFNPeMN19W4EO1aQEyFFQ4q1Spw6e9zMj/mVn0ZwdqdjaU2CZbc93Fb5dUbsw66A9DE4Lwj3kTPCdYYPbItRcgy+sMawsYiLlkAmfz4vOybg1dmHElDSyB0jKmp4b+2P4ZNyctEsKGdLZ3LlNyzSYF4TWvzmGrZ6K9uNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721144112; c=relaxed/simple;
	bh=Q3I60QZF5IfcfRJW5LZjiLma4i6XMMVJYf44JDgWyJ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=akGzy5pJDk3l4JqNLVbB7LnuO5my7mRV3pWCj2yWKFsISnIynLOgZdvgucL3DrT18ssJpBqIKn7VhmLvU1QxoLQJQT/9HlJz576c8pD22M9W0jCFmnFZauqmi1+ngyGMm2apM9sSMjj4GPPqnY184gaXgbQCfj4+YoYUdLxbM3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JtMHbgwc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JtMHbgwc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44944C116B1;
	Tue, 16 Jul 2024 15:35:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721144112;
	bh=Q3I60QZF5IfcfRJW5LZjiLma4i6XMMVJYf44JDgWyJ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JtMHbgwczZcAimwq6skTKBT75P/r4l9hvD0piuLGsgAeQBCR7CEl9qVIZWl+MLazq
	 ltysdnSTr9fWnqGb0eFHNv6ZsM63WlHeqWChV+QaTc/4LCpoasNa9yID2t2SruWPL7
	 Gy4JXvVnBkEOKqPnl02FE7Iqf/c7uB+Uc8xeDL44=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jaganath Kanakkassery <jaganath.kanakkassery@intel.com>,
	Marcel Holtmann <marcel@holtmann.org>,
	Wentao Guan <guanwentao@uniontech.com>
Subject: [PATCH 4.19 32/66] Bluetooth: Fix incorrect pointer arithmatic in ext_adv_report_evt
Date: Tue, 16 Jul 2024 17:31:07 +0200
Message-ID: <20240716152739.392263551@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152738.161055634@linuxfoundation.org>
References: <20240716152738.161055634@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jaganath Kanakkassery <jaganath.k.os@gmail.com>

commit cd9151b618da4723877bd94eae952f2e50acbc0e upstream.

In ext_adv_report_event rssi comes before data (not after data as
in legacy adv_report_evt) so "+ 1" is not required in the ptr arithmatic
to point to next report.

Signed-off-by: Jaganath Kanakkassery <jaganath.kanakkassery@intel.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Wentao Guan <guanwentao@uniontech.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/hci_event.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -5448,7 +5448,7 @@ static void hci_le_adv_report_evt(struct
 			bt_dev_err(hdev, "Dropping invalid advertising data");
 		}
 
-		ptr += sizeof(*ev) + ev->length + 1;
+		ptr += sizeof(*ev) + ev->length;
 	}
 
 	hci_dev_unlock(hdev);


