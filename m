Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031307;
	b=MLdkc8Qp4V+/3F6+1Ky9N0BOhNHjjUB9m2qgZ+IwVFQ6nrrrUb1pAf1++Fg9fVFBAXQz
	 FXVoRdqRT13tzA9D0SQaFJ5B8Um08eoODUug7xol1SSr5ZI4XdxG1XLCHxM9C2GSpLnYn
	 NlD9CEr8uDNlLzB7T9a+lYFq+WgJV5vU4+l4t+4B7c1Hzk8ubYo/Dg2pbCaM35jL1AzLq
	 mg00GoJFzWPm7rTTwaSigRPEr0KF8WXuJvlcx91jNg43NPsY7Hm8E299H0krHXF/0sbmy
	 bhSHRfUJfqUe54ycec5HDmTID1zDa5M3IqU5URUQYfapPwAdSD3ye9ovPTBKWOqancQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031307;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BydcKua2uLVepaS2isn2PyDqNeSiIr6Bac781R7Rncw=;
	b=k5HfbmxqhzOs0cmHCQ451OUejY8ynfhu+GNivsMh3r+5uG3q9m7g18dN7eXPzgw8nHKG
	 ltldttKIiqvX3UqQYY2T8LcLfG3hvQsDujC4qTZm3tWX8dyGN65GTgOBn4jOUNCHyxDEL
	 yqHMZvdYwE1j0SpgiFON4IWPmf7aaElK9HM4GBXgJkz90aJImi/A/h34vfHV6GeIGjlpC
	 xDJ3Ch3z9dWH78VZVy5tQUITUzKchWTeOhlkdzI2oaoNLvAdbPGxvdkLO1HoGEaCcCg7m
	 1V+oxzlwz2WwsVcrMnrDydFaHGGGFxiHLb81kcDGpmf9ksFBk9I22dtLb4gW6Sl6doQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CssM9d5l;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40359606A31C;
	Wed, 18 Nov 2026 19:48:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CssM9d5l
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 935CF1F000C4;
	Wed, 18 Nov 2026 19:48:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031307;
	bh=BydcKua2uLVepaS2isn2PyDqNeSiIr6Bac781R7Rncw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CssM9d5lckRhuS+IXM9IVK+I5p95IZ8qjKM+FEypJRhxZXm367U9zL5PaR+yjaNGX
	 CTDFNy1oX0Rx+0lwgZJbvVsklygHcFqJbjeG+oqG/JQ2xRUVx/qIUPS8ri0qQmKXDk
	 u7An0bwlb2TfhVsDCwx42/PAiiEEC1wB+cnp+s9I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1010/1756] cpufreq: qcom-cpufreq-hw: fix device node refcount leak in phandle parsing
Date: Wed, 18 Nov 2026 15:52:17 +0100
Message-ID: <20261118150050.349197694@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haotian Zhang <vulab@iscas.ac.cn>

[ Upstream commit 6fa50b1988b8dfd2e92a9cecba073fe4347a5e23 ]

of_parse_phandle_with_args() transfers a reference to the provider node
in out_args->np, which the caller is responsible for releasing with
of_node_put().  Neither qcom_get_related_cpus() nor
qcom_cpufreq_hw_cpu_init() ever puts args.np: they only put cpu_np, which
is a different node obtained from of_cpu_device_node_get().  The
reference is therefore leaked on every successful call, and
qcom_get_related_cpus() leaks one per present CPU.

Release args.np after the parsed index has been read in both call sites.

Fixes: 2849dd8bc72b ("cpufreq: qcom-hw: Add support for QCOM cpufreq HW driver")
Assisted-by: DeepSeek-V4.1-Flash
Signed-off-by: Haotian Zhang <vulab@iscas.ac.cn>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/qcom-cpufreq-hw.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/cpufreq/qcom-cpufreq-hw.c b/drivers/cpufreq/qcom-cpufreq-hw.c
index 05d5b2aab921a..1180d1d2e7c63 100644
--- a/drivers/cpufreq/qcom-cpufreq-hw.c
+++ b/drivers/cpufreq/qcom-cpufreq-hw.c
@@ -320,6 +320,8 @@ static void qcom_get_related_cpus(int index, struct cpumask *m)
 
 		if (index == args.args[0])
 			cpumask_set_cpu(cpu, m);
+
+		of_node_put(args.np);
 	}
 }
 
@@ -537,6 +539,7 @@ static int qcom_cpufreq_hw_cpu_init(struct cpufreq_policy *policy)
 		return ret;
 
 	index = args.args[0];
+	of_node_put(args.np);
 	data = &qcom_cpufreq.data[index];
 
 	/* HW should be in enabled state to proceed */
-- 
2.53.0



