Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50F0964CC0;
	Thu, 11 Apr 2024 10:51:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712832691; cv=none; b=KMJtdN/+ZuKe0LZdKcpKNOPWX//NZguxDWBiB0qqVPVe8HAy4JYyS1px1/f6AMcrcPhfjbx+2pqGIOQ5wjJ56E6p9wEfqbic+9eAllWd8/kThpfKZ/6EstdCgHA1ocUMulRjpVbleRbJEWELbQRyfLyucVOYL4Yf2QUHAu3r9hc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712832691; c=relaxed/simple;
	bh=pMrOuebTnzHoRaCrFFn8gb9z0B0j0pTFPq0tf/ceeBc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vp/53nIYuHOxaYwG1V3/yt4a8SOlRozMk1+rbao9Dm4sJkeAcnWAkPHFgvorZkoCZHjxy1GIMq1AJ+ULDyERdXevuOIMhnp2k5qeA0Jk3Z4aMMHWl7PItFv7ozeX6fYXlWUE3F05HqvWVGy3MmKUtI2O2liPGONuAiw0697RoQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=slCfF25L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="slCfF25L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC5B6C433C7;
	Thu, 11 Apr 2024 10:51:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712832691;
	bh=pMrOuebTnzHoRaCrFFn8gb9z0B0j0pTFPq0tf/ceeBc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=slCfF25LMaiI+a9ZEW3yncsehr3R+NM7fRDDJJHrGIzBfV8t6uyvFHWkh/DneEMuG
	 V6JRjjAKwTO0Z5ngIkcgZ0nq2qAYUVpsmG2qhKJv9+nK/+z8a2x+pSVaG/aDAllkN7
	 qgBgvd5dE4fdXZ1DG5Cwnv/PwXO+0F80EOcGmq+o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Subject: [PATCH 5.15 49/57] tty: n_gsm: require CAP_NET_ADMIN to attach N_GSM0710 ldisc
Date: Thu, 11 Apr 2024 11:57:57 +0200
Message-ID: <20240411095409.472720084@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095407.982258070@linuxfoundation.org>
References: <20240411095407.982258070@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>

commit 67c37756898a5a6b2941a13ae7260c89b54e0d88 upstream.

Any unprivileged user can attach N_GSM0710 ldisc, but it requires
CAP_NET_ADMIN to create a GSM network anyway.

Require initial namespace CAP_NET_ADMIN to do that.

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Link: https://lore.kernel.org/r/20230731185942.279611-1-cascardo@canonical.com
From: Salvatore Bonaccorso <carnil@debian.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/n_gsm.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -2827,6 +2827,9 @@ static int gsmld_open(struct tty_struct
 {
 	struct gsm_mux *gsm;
 
+	if (!capable(CAP_NET_ADMIN))
+		return -EPERM;
+
 	if (tty->ops->write == NULL)
 		return -EINVAL;
 


