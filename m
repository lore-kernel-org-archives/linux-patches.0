Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16ABA2C11D5
	for <patches@lists.linux.dev>; Sat, 25 Jul 2026 02:40:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.178.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784947248; cv=none; b=GAjx19ybPObnW84wPXiEK1HVfaxwQZn28wcqSllqn2Sn9Z5wfUORxUasQiP/sOBDZN7qYdPrqNH9RZRn+FUYdQt/lMcTYM3GEGHuVhP4nX+ceRGsfYxp/JQ+hIu81q2CX2oAxNXNfbpylLN/R6pf6mME8oM0PO29/+BiBqZ5zrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784947248; c=relaxed/simple;
	bh=s7DABp79lmouaegyvbRepnivXsOGFVUNS8Nw/huquY4=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=YQnzoiRhMZhTJV+xdI+HDvuqs9hFDyJxmHSiyJy6NIJfkaV4M7z4hk8oqPBQI4t34T3WTAwS3iFEkRy4hWTSJplyR8VvkVzbOgaOJJcwyu2Rd1e6MhypBsOZpIRndxMmWnfVVt/kImMt77uP/Jb/BDJDYXYdDksFDnOO1+lRRME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=CLSUtuhJ; arc=none smtp.client-ip=205.220.178.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="CLSUtuhJ"
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66P1ZihS3271387;
	Sat, 25 Jul 2026 02:40:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:message-id:mime-version:subject:to; s=PPS06212021; bh=zz3k5ldBc
	pYxIRhJPIqsKQfWpJ/un6hhprO2MvNgYeM=; b=CLSUtuhJpPHgJRj2EeMWjQ3Gs
	o+Z7LVwSZ3ENJrSUfYPuEvkWH76DMzn1Vlb9ly+kJbm1Kw3Lz/5yqj78vsydsH+a
	fXz7/LVWJ3J1LygD2SETa0zD/LilDYUiCB3owVDIy1hncv0p3RI676c9fg7u2Ywl
	l5nEfVNfFZG53rx61lntoAJeFxaDYUqYwiBv7U2JH20sjWVyaqsIJVxIMUmjbbHe
	JUI5+BIS0r/Vt++9mbq1AoA+j3SnpBkqE15D4ggBXdj1VKrrsBBpe4RxyW853nLL
	DKSdqTNpDNAkC/8vcChzJs2BiVe9iRT1aSm6JlcWxRCYmbTgjY4s/xFuRXtUg==
Received: from ala-exchng02.corp.ad.wrs.com (ala-exchng02.wrs.com [128.224.246.37])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4fmjnfr2dx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Sat, 25 Jul 2026 02:40:32 +0000 (GMT)
Received: from ala-exchng01.corp.ad.wrs.com (10.11.224.121) by
 ALA-EXCHNG02.corp.ad.wrs.com (10.11.224.122) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.61; Fri, 24 Jul 2026 19:40:31 -0700
Received: from pek-yzhou-d3.wrs.com (10.11.232.110) by
 ala-exchng01.corp.ad.wrs.com (10.11.224.121) with Microsoft SMTP Server id
 15.1.2507.61 via Frontend Transport; Fri, 24 Jul 2026 19:40:30 -0700
From: Yun Zhou <yun.zhou@windriver.com>
To: <gregkh@linuxfoundation.org>
CC: <harshit.m.mogalapalli@oracle.com>, <stable@vger.kernel.org>,
        <patches@lists.linux.dev>
Subject: [PATCH 6.12.y] ext4: fix fd leak in EXT4_IOC_MOVE_EXT cross-sb validation
Date: Sat, 25 Jul 2026 10:40:29 +0800
Message-ID: <20260725024029.1217577-1-yun.zhou@windriver.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI1MDAyMiBTYWx0ZWRfXztvKE/f9+bHc
 4JlG45Ev3ijoHphAbR8hyadJtwlB79hTVHU5mzggmXoCOEQL2MXGMUOyLpHRGM4l34WMBPcqVBg
 qVVphmbKJecIGAFyyUHW6LmXn8jAUyMG+tYXQoaTrEEI4R68WHPe
X-Proofpoint-ORIG-GUID: -8idVCaP8B7AXZCBnubRoz7D_pjucxBA
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI1MDAyMiBTYWx0ZWRfX+Cm7sUP0Fj5+
 9Uh1eNQsqLQq3k+LxOj+OT5jF8JQbEP03rEvCz4Hp4nxlz83UeB99TT2vK2KRW1gDWChFkBgiiy
 aeFr9aai8aJgTfrc1lyl8O0Y8tpQUul3N1PUqXeQJFeN5DyHAEd49RxYc7j/1aBBhnbc7UzOIxG
 z+D4duAJg0s0KiWhEb04D7i449xbrUIROZZhCeu6eY+AO1nmOXakH1uuIShQ5dvSwyMer5rpG6K
 9rr5ToNUkcwTEaiOF2JrRGyEpkj4bry3fQSAhUSdAHRN4WE0ZdQCAVz9eHLFNjj1D4owruKXcpg
 Ce3bNRyQOqYXW384Z8Fk/xbRuXczHAV9ThJwQFPm65z+nzBcxS872vNwOl3EqDcbEQpb5rVUKgk
 ConFhluZ39wx0F5Vf+ykdwEyqzxlxQ/Ips/ZXNE/0dmaijbCLEfp1pAgoGryRkj3xnm9nCQ6o/l
 djaBlwinuxUz3jqdqUA==
X-Authority-Analysis: v=2.4 cv=MuRiLWae c=1 sm=1 tr=0 ts=6a642220 cx=c_pps
 a=Lg6ja3A245NiLSnFpY5YKQ==:117 a=Lg6ja3A245NiLSnFpY5YKQ==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=bi6dqmuHe4P4UrxVR6um:22
 a=klDOsUkWDRETUCZYPvoE:22 a=yPCof4ZbAAAA:8 a=t7CeM3EgAAAA:8
 a=wjBiMjVWcXLmg7aGH80A:9 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-GUID: -8idVCaP8B7AXZCBnubRoz7D_pjucxBA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-25_01,2026-07-24_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 priorityscore=1501 malwarescore=0 phishscore=0 suspectscore=0
 clxscore=1015 impostorscore=0 lowpriorityscore=0 spamscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607250022

The backport of upstream commit c143957520c6 ("ext4: validate donor
file superblock early in EXT4_IOC_MOVE_EXT") uses a bare 'return -EXDEV'
which is safe upstream because the fd is managed via CLASS(fd) with
automatic cleanup (commit 8152f8201088 ("fdget(), more trivial
conversions")).

However, on 6.12.y the ioctl still uses the traditional fdget/fdput
pattern, so the bare return bypasses fdput(donor) at the mext_out label,
leaking the file reference.

Fix by setting err and using goto mext_out.

Fixes: 74796e886ca3 ("ext4: validate donor file superblock early in EXT4_IOC_MOVE_EXT")
Reported-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Signed-off-by: Yun Zhou <yun.zhou@windriver.com>
---
 fs/ext4/ioctl.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index a8a024bb62b4..e726f9dbc146 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -1372,8 +1372,10 @@ static long __ext4_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 			goto mext_out;
 		}
 
-		if (file_inode(filp)->i_sb != file_inode(fd_file(donor))->i_sb)
-			return -EXDEV;
+		if (file_inode(filp)->i_sb != file_inode(fd_file(donor))->i_sb) {
+			err = -EXDEV;
+			goto mext_out;
+		}
 
 		err = mnt_want_write_file(filp);
 		if (err)
-- 
2.43.0

