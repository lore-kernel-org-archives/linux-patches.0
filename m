Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F38841A6192;
	Tue, 30 Jul 2024 16:35:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357360; cv=none; b=Ou87LAdeXok8+rKkMuB1V8sf8kL/wlhGHDb2Zw5lFOT8S0AoEETqPBe2RPM3/rmg28cU1bpRfh5EUOjnJDbdcibmAox3vdg91TSupqmjKlR2HKealkZhFCzoJyS6Ix/ujbqqMypnRs/xU+tl//lh4sVmB9M+wN7eUwF8xXr/Xyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357360; c=relaxed/simple;
	bh=Ogz+kzssn0QchiFCKEiDRvcKcjk067GPSod8eNi2RMM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ksAyW6/dxiT9XMwhmqe1M4xxFKqBEGuVI4on0eZXT7IlyuowdE9zqovTkafn8LkPMw2V2r/YVCHv7CSYe7tOBdlH6SclFmNNEiFGhKR4EsEqhMwnhmma7hi1iPU6+kxMka/3LUehwXsMj9GwE+0RkKDOm37a8bzGiYTRmd9C9ZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oKlZqciG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oKlZqciG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F240C4AF15;
	Tue, 30 Jul 2024 16:35:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357359;
	bh=Ogz+kzssn0QchiFCKEiDRvcKcjk067GPSod8eNi2RMM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oKlZqciG1CSDvNPVQeToJ16UfU/BxNCjP4MbYQmDQm3EvAC4zRt3ngxkNzq1TMie6
	 7ybcVLvpRygw84Ih63kwlI+ztscayownSiGPUKjcKC6eDbebOXLvuRVE6nfoJVuLW7
	 gjEKPfmfJiN/2JDbyrOGGqlVcDa/ZP+WzA1KDoUU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>,
	Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 6.1 285/440] char: tpm: Fix possible memory leak in tpm_bios_measurements_open()
Date: Tue, 30 Jul 2024 17:48:38 +0200
Message-ID: <20240730151626.962803606@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>

commit 5d8e2971e817bb64225fc0b6327a78752f58a9aa upstream.

In tpm_bios_measurements_open(), get_device() is called on the device
embedded in struct tpm_chip. In the error path, however, put_device() is
not called. This results in a reference count leak, which prevents the
device from being properly released. This commit makes sure to call
put_device() when the seq_open() call fails.

Cc: stable@vger.kernel.org # +v4.18
Fixes: 9b01b5356629 ("tpm: Move shared eventlog functions to common.c")
Signed-off-by: Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/tpm/eventlog/common.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/char/tpm/eventlog/common.c
+++ b/drivers/char/tpm/eventlog/common.c
@@ -47,6 +47,8 @@ static int tpm_bios_measurements_open(st
 	if (!err) {
 		seq = file->private_data;
 		seq->private = chip;
+	} else {
+		put_device(&chip->dev);
 	}
 
 	return err;


