Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7F5423752
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 12:04:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66022C433C7;
	Wed, 20 Sep 2023 12:04:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695211471;
	bh=r4WvqvP57NBBscOnY/PGCU9119x+Qik0Fs0t0I/ImX4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gANWHduKjUxfejN1W4xPkUBkGoWeG/9lfnyyAooJEA7h3oqJ1g1Vr6yLnb9j+iPR/
	 JJ9FTGmCg9wajQO9bTgcMKBSBCWntOmIPZgz3w8pDZuJB5uqZmU7OX5V7bF9LsYp0c
	 YTVnRpSm/COdKPUHjPHkIg+XYnhqkBd6DGv42Jko=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lin Ma <linma@zju.edu.cn>,
	Chris Leech <cleech@redhat.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 080/186] scsi: be2iscsi: Add length check when parsing nlattrs
Date: Wed, 20 Sep 2023 13:29:43 +0200
Message-ID: <20230920112839.765173914@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112836.799946261@linuxfoundation.org>
References: <20230920112836.799946261@linuxfoundation.org>
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

4.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lin Ma <linma@zju.edu.cn>

[ Upstream commit ee0268f230f66cb472df3424f380ea668da2749a ]

beiscsi_iface_set_param() parses nlattr with nla_for_each_attr and assumes
every attributes can be viewed as struct iscsi_iface_param_info.

This is not true because there is no any nla_policy to validate the
attributes passed from the upper function iscsi_set_iface_params().

Add the nla_len check before accessing the nlattr data and return EINVAL if
the length check fails.

Fixes: 0e43895ec1f4 ("[SCSI] be2iscsi: adding functionality to change network settings using iscsiadm")
Signed-off-by: Lin Ma <linma@zju.edu.cn>
Link: https://lore.kernel.org/r/20230723075938.3713864-1-linma@zju.edu.cn
Reviewed-by: Chris Leech <cleech@redhat.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/be2iscsi/be_iscsi.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/scsi/be2iscsi/be_iscsi.c b/drivers/scsi/be2iscsi/be_iscsi.c
index 43a80ce5ce6a9..0e95bccac32e3 100644
--- a/drivers/scsi/be2iscsi/be_iscsi.c
+++ b/drivers/scsi/be2iscsi/be_iscsi.c
@@ -442,6 +442,10 @@ int beiscsi_iface_set_param(struct Scsi_Host *shost,
 	}
 
 	nla_for_each_attr(attrib, data, dt_len, rm_len) {
+		/* ignore nla_type as it is never used */
+		if (nla_len(attrib) < sizeof(*iface_param))
+			return -EINVAL;
+
 		iface_param = nla_data(attrib);
 
 		if (iface_param->param_type != ISCSI_NET_PARAM)
-- 
2.40.1



