Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7340F63C;
	Thu, 15 Aug 2024 14:15:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723731328; cv=none; b=l3sLptvrcDQnfGyn3mkje+MaR1lIp9NoRWJn/KhsvXOUza2uf10jb2MfOXHNtRWcI59J/g0K7/HOx8TYrsugHE0TiZ8hkA7KQH5IwodJgrnQ7vbUwB2m/WsTtXrubJeNuzL9ufCq5pjtKM6hIsxpHg3TJyuTJpK+M1NDFJQWvcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723731328; c=relaxed/simple;
	bh=Ywgg1KriyVcTig7l7qw+nCk8AsuZQL+yn4joOS+a6uA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jPVZ2NURnutDBpauRDvhfeHJ1w41FKPKuCDWp8dFZFOy80RNfMqyllki8GQ6mTjoxMUyLUFHjddAJaUWyXKkeRXDTLd4kd0k+dv8P+qMFmRR5BHpb4BFMeMtTRoFxNwJA2O5NbH5phSFp7i5DWBILmdz90ZxrPRTFU5P9Glhmq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TJuvxYbP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TJuvxYbP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFDE5C32786;
	Thu, 15 Aug 2024 14:15:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723731328;
	bh=Ywgg1KriyVcTig7l7qw+nCk8AsuZQL+yn4joOS+a6uA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TJuvxYbPjpIC8fp0P394HF3KyVkOoSL0/acLzTG8WJxqjyqtRt4FJ7mK+r1U5nDAE
	 DWKuvmCYluwI/FguGuB9cqPJqihrIVBkWq2IavF000zZ32GJete8py+i6TGXj7fAQM
	 ULMMgfgrFea7SbboBHa/YJVjxqA0Q5/OBTLvsLi4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>,
	Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 5.4 093/259] char: tpm: Fix possible memory leak in tpm_bios_measurements_open()
Date: Thu, 15 Aug 2024 15:23:46 +0200
Message-ID: <20240815131906.394059054@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131902.779125794@linuxfoundation.org>
References: <20240815131902.779125794@linuxfoundation.org>
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


