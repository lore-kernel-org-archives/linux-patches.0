Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DD392F9D85;
	Thu, 28 May 2026 20:49:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780001355; cv=none; b=sQW/80sJN8hSByzgDHa6OLw/npWoPNkcnPJ+qJJts8pU3tRNsslmTkg2ugZ9bAgs6nPuWTNcKHiUD6rAydf7a8jw30OOQKs0fYexIlFkMAdgoDTzCa7u1Iojvl5vwGagoRWDKEWQhpltv3qPyrYIlakl5UncGQEmbACkiMPixkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780001355; c=relaxed/simple;
	bh=Iox0gjl2M7LBwXOAmO+cn001f29iA69lArX5f+xIowM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sh+9MkWd6q0AprGORMalEC/ucmpd8sZ5SN28boW5duTAI7z/HuPHDTXuF3vLsXbx61oD0+8hU77ri0p4MePgeG9CNd7qs5FmRuu2eCJlkUj8a8H/YV7oSvf8EtLNXGeFwHdu0Ta9k8/Hnv5Aa6QXGKD+TWV+GOPQWU/2flsqt7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iURwg8BZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iURwg8BZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07C221F000E9;
	Thu, 28 May 2026 20:49:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780001354;
	bh=OCaPPCwYQl6iVvCz9QZaBVD6ryHc0RGZGm7uvdiTm+0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iURwg8BZNKfYkSjRLYgaPZoPW1AhhTC7dlNCjCa8P/3/qYKp1Doa4m9i2i9dXaxc9
	 dKWUCt38l6v48EGz+i7hN1cIkKKjroYsTV3XY+qXh4peB21hYi0SZhOTcqiMHB5/P7
	 0yw6sRhKoasGYsi8OwWmHkmVFmoyOCpsL+MQTSHw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 097/186] HID: uclogic: Fix regression of input name assignment
Date: Thu, 28 May 2026 21:49:37 +0200
Message-ID: <20260528194931.552708804@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194928.941004471@linuxfoundation.org>
References: <20260528194928.941004471@linuxfoundation.org>
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

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 487359284509a6745e14b8c0518768bc277809b0 ]

The previous fix for adding the devm_kasprintf() return check in the
commit bd07f751208b ("HID: uclogic: Add NULL check in
uclogic_input_configured()") changed the condition of hi->input->name
assignment, and it resulted in missing the proper input device name
when no custom suffix is defined.

Restore the conditional to the original content to address the
regression.

Fixes: bd07f751208b ("HID: uclogic: Add NULL check in uclogic_input_configured()")
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-uclogic-core.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/hid-uclogic-core.c b/drivers/hid/hid-uclogic-core.c
index 45de01dea4b1c..d4cf8846f326a 100644
--- a/drivers/hid/hid-uclogic-core.c
+++ b/drivers/hid/hid-uclogic-core.c
@@ -142,7 +142,9 @@ static int uclogic_input_configured(struct hid_device *hdev,
 			suffix = "System Control";
 			break;
 		}
-	} else {
+	}
+
+	if (suffix) {
 		hi->input->name = devm_kasprintf(&hdev->dev, GFP_KERNEL,
 						 "%s %s", hdev->name, suffix);
 		if (!hi->input->name)
-- 
2.53.0



