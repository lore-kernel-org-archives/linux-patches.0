Received: from mr85p00im-ztdg06021801.me.com (mr85p00im-ztdg06021801.me.com [17.58.23.195])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 943AC6312A
	for <patches@lists.linux.dev>; Tue, 23 Jan 2024 01:56:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=17.58.23.195
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974999; cv=none; b=hGrIgbiaiuQblnI46NudzYj1w10gKU0djb0eaPaY88bEkG6Alk+suxywSc0C4CHK1cgFNBu95olnVMZ5bAJC7AbYkoxI1U2OnXBE/8h/1MDNwC5GW8ZA56VhNURzGH0p+Slanh75CveeUJcmoYQuyzXMe7EgYvaqOebxjl1W+YM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974999; c=relaxed/simple;
	bh=0YKWwYYZkyTqbHeSmaZaeO1G2t3F78JXlb8e4VdGU/U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ASDx1mhlxtQV6l+se+5as9HWb44FTZiV6B2rk4OsTbk20QxF+NXpenm4qBExImE/nh1BOgWhEo08uTKUQE/w59Ke+ojwuZkV0ZN4Vurqn2qOJhkxGYIGRhOkH8rwfYIK4Vq8iUoMKkwtSgK9i4uUpjYNH+EmiBIqIk4+Ce/f5es=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=danm.net; spf=pass smtp.mailfrom=danm.net; dkim=pass (2048-bit key) header.d=danm.net header.i=@danm.net header.b=TlOSSaHX; arc=none smtp.client-ip=17.58.23.195
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=danm.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=danm.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=danm.net header.i=@danm.net header.b="TlOSSaHX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=danm.net; s=sig1;
	t=1705974997; bh=0YKWwYYZkyTqbHeSmaZaeO1G2t3F78JXlb8e4VdGU/U=;
	h=From:To:Subject:Date:Message-ID:MIME-Version;
	b=TlOSSaHXb8qb4KOjz7vOXc9/mTg6k3Xbo7ySg4thSndTLtRAiQhBxhkvYVLgon3DZ
	 C3YdoMZ4JvfasbKhbLoYuRF9pVmD+K/FJ5LL3sV1t5SZ2ojYcGhFxCMtofB9t3Xjc4
	 LFpTaweNiAee6jyNBjjHuvo0LS2JKwLW7pUWdP13XpSWrCc1TfAZx5nhs33QyC7HQ2
	 UTMeYepypXQZApOlZnvp2zDctw9umgWGM3YdhBK8HJU2qAsAeSDW7Y5/idrsAj/D9r
	 F3K80NLGASOiKsZJwZD9np/S4Pls+KLfSOQpiB2acjs5JprsgSKKZKPCGnArcfrWWe
	 3KUrluqIU2yQg==
Received: from hitch.danm.net (mr38p00im-dlb-asmtp-mailmevip.me.com [17.57.152.18])
	by mr85p00im-ztdg06021801.me.com (Postfix) with ESMTPSA id D9E70D0024C;
	Tue, 23 Jan 2024 01:56:36 +0000 (UTC)
From: Dan Moulding <dan@danm.net>
To: gregkh@linuxfoundation.org
Cc: junxiao.bi@oracle.com,
	logang@deltatee.com,
	patches@lists.linux.dev,
	song@kernel.org,
	stable@vger.kernel.org,
	yukuai3@huawei.com
Subject: [PATCH 6.7 438/641] md: bypass block throttle for superblock update
Date: Mon, 22 Jan 2024 18:56:34 -0700
Message-ID: <20240123015634.7761-1-dan@danm.net>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235831.717823754@linuxfoundation.org>
References: <20240122235831.717823754@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: B6Rp4Ubjiw7MOkKEuUTfRJ5SrSpojMq2
X-Proofpoint-GUID: B6Rp4Ubjiw7MOkKEuUTfRJ5SrSpojMq2
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-22_12,2024-01-22_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0
 mlxlogscore=323 mlxscore=0 adultscore=0 suspectscore=0 bulkscore=0
 clxscore=1030 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2308100000 definitions=main-2401230011

Please see https://lore.kernel.org/all/20240123013514.7366-1-dan@danm.net/

In particular:

> Coincidentally, I see it seems this second commit was picked up for
> inclusion in 6.7.2 just today. I think that needs to NOT be
> done. Instead the stable series should probably revert 0de40f76d567
> until the regression is successfully dealt with on master. Probably no
> further changes related to this patch series should be backported
> until then.

Thanks,

-- Dan
