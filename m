Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 889A2179641;
	Wed,  3 Jul 2024 11:03:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720004587; cv=none; b=cnklzGfFOQxrxCJXUj7HVe81sgLAun5TYDqTzpWqyoqtjOg6q04zHuL9A2zBzepV8cA73whhM09hP+IpprYAtKTiz8sHMyMXXr75W0GDn/gFphVn7B/8nk66rU+eclSTdmQNaq94GAybTODeVjZ78LdpKlLrQ0xkeSs7/34EBvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720004587; c=relaxed/simple;
	bh=ooa4WhP2wiJmd4RcUt14I4G+JpXGROJmx2t1m72A4QM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=n1xiCf6elYWDoqNFESFsSGA6DHI/sfGjnKm96tgYm8LugEc+Hq1Bp+znGC3L8oaISVy3TzZvVe2h8Jq+OvyaPuAj72peDopKHJPCzjA8uAeCqLP496cJfp27tZGYxplViVd+11LeEi3UHf1XxpaTDshszOEeu34VezKrTsscYps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XVh8oLiD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XVh8oLiD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0ED41C2BD10;
	Wed,  3 Jul 2024 11:03:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720004587;
	bh=ooa4WhP2wiJmd4RcUt14I4G+JpXGROJmx2t1m72A4QM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XVh8oLiDQLVUePbijNj0sJZpW7WgZtMr3eTn7lcrfkM8HV+ocvPaA1565ukNDGRWb
	 c3U7aljjASJbDsvKQ//2EBOTgC8FMrfYfpHXG4R2DLvU7FeDbxALCFQH+SS/Pm6khb
	 M1Pl5gfKNOM81GZRNDhSU1cwgPl1paCWd8iiq3bc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jos=C3=A9=20Exp=C3=B3sito?= <jose.exposito89@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 060/290] HID: logitech-dj: Fix memory leak in logi_dj_recv_switch_to_dj_mode()
Date: Wed,  3 Jul 2024 12:37:21 +0200
Message-ID: <20240703102906.469051259@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102904.170852981@linuxfoundation.org>
References: <20240703102904.170852981@linuxfoundation.org>
User-Agent: quilt/0.67
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: José Expósito <jose.exposito89@gmail.com>

[ Upstream commit ce3af2ee95170b7d9e15fff6e500d67deab1e7b3 ]

Fix a memory leak on logi_dj_recv_send_report() error path.

Fixes: 6f20d3261265 ("HID: logitech-dj: Fix error handling in logi_dj_recv_switch_to_dj_mode()")
Signed-off-by: José Expósito <jose.exposito89@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-logitech-dj.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/hid-logitech-dj.c b/drivers/hid/hid-logitech-dj.c
index f4d79ec826797..bda9150aa372a 100644
--- a/drivers/hid/hid-logitech-dj.c
+++ b/drivers/hid/hid-logitech-dj.c
@@ -1218,8 +1218,10 @@ static int logi_dj_recv_switch_to_dj_mode(struct dj_receiver_dev *djrcv_dev,
 		 */
 		msleep(50);
 
-		if (retval)
+		if (retval) {
+			kfree(dj_report);
 			return retval;
+		}
 	}
 
 	/*
-- 
2.43.0



