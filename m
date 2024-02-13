Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8693BA93C;
	Tue, 13 Feb 2024 17:40:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707846043; cv=none; b=OB4M0fDIdHn9tl+LAj0Tfp/HeBTNiCTCCe66ENhyug0DaGoIqJ2/5KyvOcJzh1RhfEq+PCoQdC37Be7EWJpL+OwiIJ4G5+FgtzEXl8Po3cio1P2/DZp/7zGKHIwqGfiwyurs/J/D9JNhEt4Qp3TcDkof3iwZJXobygJp14KLj5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707846043; c=relaxed/simple;
	bh=l8oGhVh5kPLNpDIHgoPy2RR0WUNHTiiVnDGRZ+JmKNs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EtfZ80VRKAdz6dQ62dsN46aQbcaGnPZ6YEXcUBoFtXxy0sbMpJONNHbB52b71XS9zEAEmXTjJUTE18lg3ubV5vrM8X74+BA1+7vPUnQsdrv2g/Du0LZYkpxCDao9b+2DHumZBanHNS+RqsG/mnM0G4hoH+s/zLQYE6Eo1Kp1eGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fk+d7Q4p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fk+d7Q4p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBA39C433C7;
	Tue, 13 Feb 2024 17:40:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707846043;
	bh=l8oGhVh5kPLNpDIHgoPy2RR0WUNHTiiVnDGRZ+JmKNs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fk+d7Q4pjFYwT3h1g9vVzzyeS4/DzawdGPNq44nNXnm6hiakxOQXAsyDCfkTw2kSC
	 jUcnn3MTgxy4rbMuMiGPLQg5nxUdksS2USQ8wAZgxmlHYGbgNdScj5eRbUrqDxJcRI
	 sS3CmIkWlRZn81+KNk3ubV63Pw+zoeSOVcTCrGcw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 6.7 120/124] bcachefs: time_stats: Check for last_event == 0 when updating freq stats
Date: Tue, 13 Feb 2024 18:22:22 +0100
Message-ID: <20240213171857.233537542@linuxfoundation.org>
X-Mailer: git-send-email 2.43.1
In-Reply-To: <20240213171853.722912593@linuxfoundation.org>
References: <20240213171853.722912593@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kent Overstreet <kent.overstreet@linux.dev>

commit 7b508b323b2ec45be59769bd4e4aeba729c52cf6 upstream.

This fixes spurious outliers in the frequency stats.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/bcachefs/util.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/fs/bcachefs/util.c
+++ b/fs/bcachefs/util.c
@@ -362,14 +362,15 @@ static inline void bch2_time_stats_updat
 		bch2_quantiles_update(&stats->quantiles, duration);
 	}
 
-	if (time_after64(end, stats->last_event)) {
+	if (stats->last_event && time_after64(end, stats->last_event)) {
 		freq = end - stats->last_event;
 		mean_and_variance_update(&stats->freq_stats, freq);
 		mean_and_variance_weighted_update(&stats->freq_stats_weighted, freq);
 		stats->max_freq = max(stats->max_freq, freq);
 		stats->min_freq = min(stats->min_freq, freq);
-		stats->last_event = end;
 	}
+
+	stats->last_event = end;
 }
 
 static noinline void bch2_time_stats_clear_buffer(struct bch2_time_stats *stats,


