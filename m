Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 091CCDDB1;
	Thu, 13 Jun 2024 11:39:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718278793; cv=none; b=lwzBIPaMDOw0WopLpVYjNUcCv9fvuOuH7ssBWcfAeOts7NMF1U/8raNK9Pe8NhWEeQ+zuZKa7m/BroExZQHfJJJ4c6VuXKK4CWFosXAn1A1Z3dgBQv0cnEtEYNfTfIPhTY4AaNHvHj7vG5H6KVkjpd4yUNvPJB6leZsVl/Ok+t8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718278793; c=relaxed/simple;
	bh=lDaOhC2F4y4Rt8yrJmMqcRcwTzS5gpZazGhUfL7s5n8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mxMh/WPKVjkNPhQFQU8qVQK3JLPAnDgSnirj1kE4989SSlJKZ4YfDaa7pWGUhg5AfYBWM08iMfI2ILVCop6Rw30PAuTWAEMj7sreImF5aNJfa+pB3XdHF76v/EPzZD9tmYrTsgopllqIbCobJs0pam1S6viIx/OCxlExpIqSW7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e1ONmwNJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e1ONmwNJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 862E6C2BBFC;
	Thu, 13 Jun 2024 11:39:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718278792;
	bh=lDaOhC2F4y4Rt8yrJmMqcRcwTzS5gpZazGhUfL7s5n8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e1ONmwNJw8jmnprEk9zmyHtbrw59px+yJQofeuTzLCV/7mR37jWdvhvt3O8hkiPSj
	 +oWLGbT+qoL/XlBXOymZfEEdwNSlUJzhzCXN8k9B4bDfDkZfNKvnO01qFWDbeIEXk8
	 yk/k05NOsFc3LKxG/aj72t1tffAcrBxwddwDGJCY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Burakov <a.burakov@rosalinux.ru>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 071/213] media: ngene: Add dvb_ca_en50221_init return value check
Date: Thu, 13 Jun 2024 13:31:59 +0200
Message-ID: <20240613113230.746453529@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.969123070@linuxfoundation.org>
References: <20240613113227.969123070@linuxfoundation.org>
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

From: Aleksandr Burakov <a.burakov@rosalinux.ru>

[ Upstream commit 9bb1fd7eddcab2d28cfc11eb20f1029154dac718 ]

The return value of dvb_ca_en50221_init() is not checked here that may
cause undefined behavior in case of nonzero value return.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 25aee3debe04 ("[media] Rename media/dvb as media/pci")
Signed-off-by: Aleksandr Burakov <a.burakov@rosalinux.ru>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/pci/ngene/ngene-core.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/pci/ngene/ngene-core.c b/drivers/media/pci/ngene/ngene-core.c
index aa60559bbbb49..ee36beda54273 100644
--- a/drivers/media/pci/ngene/ngene-core.c
+++ b/drivers/media/pci/ngene/ngene-core.c
@@ -1505,7 +1505,9 @@ static int init_channel(struct ngene_channel *chan)
 	}
 
 	if (dev->ci.en && (io & NGENE_IO_TSOUT)) {
-		dvb_ca_en50221_init(adapter, dev->ci.en, 0, 1);
+		ret = dvb_ca_en50221_init(adapter, dev->ci.en, 0, 1);
+		if (ret != 0)
+			goto err;
 		set_transfer(chan, 1);
 		chan->dev->channel[2].DataFormatFlags = DF_SWAP32;
 		set_transfer(&chan->dev->channel[2], 1);
-- 
2.43.0



