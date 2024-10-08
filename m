Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F9561D54D1;
	Tue,  8 Oct 2024 12:47:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728391649; cv=none; b=Yjko8jxY+jvuTnwIVcLoktViFkqiIEbu+NZ8kXYTslhpJOiWS8VpAYC3OJRPliIOL0kis1N2hE7x09ogH2l1h2tcH0Zh7B6XS9HTDJULk0gRrLhagJ+fwH6B16EWuq/SbhdnGdVvlbyzgbpNeOCLEjyrSwp1cgCzq3lIDECSVRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728391649; c=relaxed/simple;
	bh=Cj8BgoiRbmTTQ9ELnIv9RWfuyVEC3YlL+um/nf6giCY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tEv0nFBfmjbo3BwVLd5vXGB+/Yx6rIcSxpHVpwDvzQMziv7dmhcoMsdVLcTDSg/CHCODoasJo//6fMoRaUXG0zRH8FOl6a5/cfIDtAWdfQONKjNomV/lzl/7zg7DrJc37koGIKDjRL+dOuV7YMcfLQMrGeSCSngX5wIz8s6VhDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lpfPZu7X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lpfPZu7X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12957C4CEC7;
	Tue,  8 Oct 2024 12:47:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728391649;
	bh=Cj8BgoiRbmTTQ9ELnIv9RWfuyVEC3YlL+um/nf6giCY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lpfPZu7Xto7xhJ2PJBftg4hcebHizera4Ju7LDZYcbX8U6fp96sN8ORgDnCP0CzCZ
	 UtMX/RQwNR1uZArUtX3afxENs3oNOmlMe1URPNlX3/QndTjTyi44dAoIOnuu9xBTdS
	 mf2WacWZdaQ422SBGmmDLJ6a/kutC3vmS57lJe7Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 182/558] ALSA: asihpi: Fix potential OOB array access
Date: Tue,  8 Oct 2024 14:03:32 +0200
Message-ID: <20241008115709.516303168@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 7b986c7430a6bb68d523dac7bfc74cbd5b44ef96 ]

ASIHPI driver stores some values in the static array upon a response
from the driver, and its index depends on the firmware.  We shouldn't
trust it blindly.

This patch adds a sanity check of the array index to fit in the array
size.

Link: https://patch.msgid.link/20240808091454.30846-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/asihpi/hpimsgx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/pci/asihpi/hpimsgx.c b/sound/pci/asihpi/hpimsgx.c
index d0caef2994818..b68e6bfbbfbab 100644
--- a/sound/pci/asihpi/hpimsgx.c
+++ b/sound/pci/asihpi/hpimsgx.c
@@ -708,7 +708,7 @@ static u16 HPIMSGX__init(struct hpi_message *phm,
 		phr->error = HPI_ERROR_PROCESSING_MESSAGE;
 		return phr->error;
 	}
-	if (hr.error == 0) {
+	if (hr.error == 0 && hr.u.s.adapter_index < HPI_MAX_ADAPTERS) {
 		/* the adapter was created successfully
 		   save the mapping for future use */
 		hpi_entry_points[hr.u.s.adapter_index] = entry_point_func;
-- 
2.43.0



