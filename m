Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA0CA268C55;
	Tue,  8 Apr 2025 11:10:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110613; cv=none; b=n9F74BKutmJ8aXeHdMySxzPL+y4FhpWbhb/bGb1qjjIvC0jEZt/w0owxhuHq643aZ3JVl1O/Avzme8O+jQxdZo7E0EYB5KfbIjbtUTkmYVfFzf/8chEZUxG4d7dK1dFfW5hAcRWo2PLh7pKzw1hP51vMB2HOp/0HBrXeFBrILFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110613; c=relaxed/simple;
	bh=h/HON4FFBZGnN13Xaq9TQmqMAtSeV+KQkOSanOk5i68=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YTVJ7lXRbjYSpvGvyWIdega6MRwVwUlZlDU/19Cb2sVK5lqXfL+THCeJsset7DjRN/bOsW/p2knn4Xtw5NjFZDZ2Xp9S8YLEOlIfWbYvPRi2r/0eBvMsmfvcFJVrjvLjU27dbxKEEwlxQdnRbyQcP5z0vcmw+wEJpHQ5VQOMQso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p5ZaBWIw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p5ZaBWIw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 463A3C4CEE5;
	Tue,  8 Apr 2025 11:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110613;
	bh=h/HON4FFBZGnN13Xaq9TQmqMAtSeV+KQkOSanOk5i68=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p5ZaBWIw+LPoWY9RPIhwXd4CLz1/LJOd8V5k5nHhS9Y4zyDy3K0meGIlb3wwac9oV
	 Ugd3D2KBFlnsjc2yGd4KDme+GqxlCzI84znbzKKVf46fqmjTKp3wDyZaOC+Vx8bJTw
	 vE0gofDJEmoN8FC17NUn8PeBNUdbfNjFDgNx6S+Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karthikeyan Periyasamy <quic_periyasa@quicinc.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Aditya Kumar Singh <aditya.kumar.singh@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 090/731] wifi: ath12k: Fix locking in "QMI firmware ready" error paths
Date: Tue,  8 Apr 2025 12:39:47 +0200
Message-ID: <20250408104916.362770966@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit b9c7299a3341a737622e4de45b9c27e60ad01e3b ]

If ag->mutex has been locked, unlock it before returning. If it has not
been locked, do not unlock it before returning. These bugs have been
detected by the Clang thread-safety analyzer.

Cc: Karthikeyan Periyasamy <quic_periyasa@quicinc.com>
Cc: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Fixes: ee146e11b4d9 ("wifi: ath12k: refactor core start based on hardware group")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Aditya Kumar Singh <aditya.kumar.singh@oss.qualcomm.com>
Link: https://patch.msgid.link/20250206221317.3845663-1-bvanassche@acm.org
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/core.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath12k/core.c b/drivers/net/wireless/ath/ath12k/core.c
index 0606116d6b9c4..212cd935e60a0 100644
--- a/drivers/net/wireless/ath/ath12k/core.c
+++ b/drivers/net/wireless/ath/ath12k/core.c
@@ -1122,16 +1122,18 @@ int ath12k_core_qmi_firmware_ready(struct ath12k_base *ab)
 		ath12k_core_stop(ab);
 		mutex_unlock(&ab->core_lock);
 	}
+	mutex_unlock(&ag->mutex);
 	goto exit;
 
 err_dp_free:
 	ath12k_dp_free(ab);
 	mutex_unlock(&ab->core_lock);
+	mutex_unlock(&ag->mutex);
+
 err_firmware_stop:
 	ath12k_qmi_firmware_stop(ab);
 
 exit:
-	mutex_unlock(&ag->mutex);
 	return ret;
 }
 
-- 
2.39.5



