Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFF73442FDA;
	Thu, 20 Aug 2026 17:43:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247789; cv=none; b=aKQ+rWBpfhPzaXR+246g89xjAYFJS1U57csBse28dFXkBTPilb026Sziz9uzJ8zQ/S3vNdKRTZf4f/OC5UM/GzpD5h0pBJOtpq3leLJG1hNjvDcsQIYjkqGJ9bjyKIBtZyVcTzHEren4WmUev8tRUSrsje7Zf/zlMMNnGOpOa18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247789; c=relaxed/simple;
	bh=hsnsqoUjduxi1xbNb6Fm7wHU7AsMew6XWYZEUVFGdKs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ouZEo8fokhYdmW82uFx0x/jjq5i2APuGgkM2rqwaY83QMiCeyfzr5Z1ahx8V11cjrtAMNTQgbF/N63Iifm6q0WttTEcifBt3b2vOJhFJImlzOKsij8zUTS3lqebpqn7wD7GHLiH0vgv4xpWUCS8po0XGkyjKKJXxUbArUMkpPMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jAqLzCyG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jAqLzCyG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9C941F000E9;
	Thu, 20 Aug 2026 17:43:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247787;
	bh=KK6AKkyNqPsp2SwWzmgwZ7DVL/M57Ieby9PbGbneQeY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jAqLzCyGx3zcAaFA9HE4k8DkcKQU/yHjEGSLdFImGpGPGwc1QrS/VaszpmhUNLxAJ
	 WDqGiGCUq13IuNmhv34DN5qhyhQsfLYsHtzIyFGVP3tvQF5B58LQkhDf9BKNU8lcqN
	 ZdIia+HucxbvivFea+qZP4DjGz0irbPHwKYALWgs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	vega@nebusec.ai,
	Victor Nogueira <victor@mojatatu.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 162/166] net/sched: cls_bpf: reject dev-bound programs bound to a different device
Date: Thu, 20 Aug 2026 16:57:01 +0200
Message-ID: <20260820145216.036595672@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145211.194104353@linuxfoundation.org>
References: <20260820145211.194104353@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jamal Hadi Salim <jhs@mojatatu.com>

[ Upstream commit 120977e2c096deea4e866e4273be9220b957c29e ]

cls_bpf_prog_from_efd() obtained a SCHED_CLS program via
bpf_prog_get_type_dev() but never verified that a device-bound (offloaded)
program's bound netdev matches the TC netdev the classifier is being
attached to. This let a program loaded with prog_ifindex for device A be
attached via cls_bpf + skip_sw to device B; deleting device A then
destroyed the program's offload state while it was still attached to
device B, triggering a netdevsim WARN (panic with panic_on_warn=1).

Mirror the XDP attach path (net/core/dev.c) and reject the attach with
-EINVAL when a dev-bound program's bound device does not match the
target device.

Fixes: 2b3486bc2d23 ("bpf: Introduce device-bound XDP programs")
Reported-by: vega@nebusec.ai
Tested-by: Victor Nogueira <victor@mojatatu.com>
Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>
Acked-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://patch.msgid.link/20260809094418.901607-1-jhs@mojatatu.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/cls_bpf.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/net/sched/cls_bpf.c b/net/sched/cls_bpf.c
index cede21257d27c..8ca716bf9e42b 100644
--- a/net/sched/cls_bpf.c
+++ b/net/sched/cls_bpf.c
@@ -374,7 +374,8 @@ static int cls_bpf_prog_from_ops(struct nlattr **tb, struct cls_bpf_prog *prog)
 }
 
 static int cls_bpf_prog_from_efd(struct nlattr **tb, struct cls_bpf_prog *prog,
-				 u32 gen_flags, const struct tcf_proto *tp)
+				 u32 gen_flags, const struct tcf_proto *tp,
+				 struct netlink_ext_ack *extack)
 {
 	struct bpf_prog *fp;
 	char *name = NULL;
@@ -388,6 +389,19 @@ static int cls_bpf_prog_from_efd(struct nlattr **tb, struct cls_bpf_prog *prog,
 	if (IS_ERR(fp))
 		return PTR_ERR(fp);
 
+	if (bpf_prog_is_dev_bound(fp->aux)) {
+		struct tcf_block *block = tp->chain->block;
+		struct net_device *dev;
+
+		dev = block->q ? qdisc_dev(block->q) : NULL;
+		if (!dev || !bpf_offload_dev_match(fp, dev)) {
+			NL_SET_ERR_MSG(extack,
+				       "Program is bound to a different device");
+			bpf_prog_put(fp);
+			return -EINVAL;
+		}
+	}
+
 	if (tb[TCA_BPF_NAME]) {
 		name = nla_memdup(tb[TCA_BPF_NAME], GFP_KERNEL);
 		if (!name) {
@@ -492,7 +506,7 @@ static int cls_bpf_change(struct net *net, struct sk_buff *in_skb,
 	prog->gen_flags = gen_flags;
 
 	ret = is_bpf ? cls_bpf_prog_from_ops(tb, prog) :
-		cls_bpf_prog_from_efd(tb, prog, gen_flags, tp);
+		cls_bpf_prog_from_efd(tb, prog, gen_flags, tp, extack);
 	if (ret < 0)
 		goto errout_idr;
 
-- 
2.53.0



