Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE1004680;
	Thu, 21 Jul 2022 15:28:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658417296; x=1689953296;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=WZ59twi+Y234fwpfoBS9XgGliCsgnLhK4MhvmcDYmj0=;
  b=F08vGvwJVl7p+ONCRn7OJUekDvq/ExADiBDCmAF86Mt5Yck06QA6CjXo
   b87+hvzFHIpw3BsV41G4zbRljzVAFe+nOJKvU64AcVuMjcR8dwPyVf9+w
   xFto/38s7nHOzDf15zOAS+FnFa46NTpf343K1Zaa8bB1J6+5rLHqGEBmz
   BmQS4jzORijktmaSCunWx/K5u7Ox0B1tHvdu2bqIbMeqVRZ7QIU2M1lsj
   6GjnxLUh622MvF2Hl4Wgg+jX7ZCw7liPNgIW4rGprS6FeIjsnZnPmIwh3
   ctQi1TdQdwH6zhreLVguuRlI2uHIXGNSUsiR0GYp3816rPh0981rAqey8
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10414"; a="287085991"
X-IronPort-AV: E=Sophos;i="5.93,290,1654585200"; 
   d="scan'208";a="287085991"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2022 08:28:16 -0700
X-IronPort-AV: E=Sophos;i="5.93,290,1654585200"; 
   d="scan'208";a="656794382"
Received: from aslawinx-mobl.ger.corp.intel.com (HELO [10.99.249.149]) ([10.99.249.149])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2022 08:28:11 -0700
Message-ID: <d8e8e5e5-001d-5f22-b22c-aaea16ed8719@linux.intel.com>
Date: Thu, 21 Jul 2022 17:28:09 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH] ASoC: Intel: avs: Mark avs_path_module_type_create() as
 noinline
Content-Language: en-US
To: Mark Brown <broonie@kernel.org>
Cc: Liam Girdwood <liam.r.girdwood@linux.intel.com>,
 Cezary Rojewski <cezary.rojewski@intel.com>,
 Kai Vehmanen <kai.vehmanen@linux.intel.com>,
 Bard Liao <yung-chuan.liao@linux.intel.com>, llvm@lists.linux.dev,
 Nick Desaulniers <ndesaulniers@google.com>,
 Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
 Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
 Nathan Chancellor <nathan@kernel.org>, Tom Rix <trix@redhat.com>,
 patches@lists.linux.dev, alsa-devel@alsa-project.org,
 Peter Ujfalusi <peter.ujfalusi@linux.intel.com>, linux-kernel@vger.kernel.org
References: <20220720185228.3182663-1-nathan@kernel.org>
 <c00a8b5e-6def-971a-d4f2-cd65c95fe430@linux.intel.com>
 <YtllwRY6F93uYRxz@sirena.org.uk>
From: =?UTF-8?Q?Amadeusz_S=c5=82awi=c5=84ski?=
 <amadeuszx.slawinski@linux.intel.com>
In-Reply-To: <YtllwRY6F93uYRxz@sirena.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 7/21/2022 4:42 PM, Mark Brown wrote:
> On Thu, Jul 21, 2022 at 02:25:20PM +0200, Amadeusz Sławiński wrote:
>> On 7/20/2022 8:52 PM, Nathan Chancellor wrote:
> 
>>> This warning is also visible with allmodconfig on other architectures.
> 
>> My first question would be what clang does differently in this configuration
>> (ARM) than in all other configurations (x86, etc.) and gcc.
> 
> See above from Nathan's commit message...

Ah, missed that. Anyway, what about if we replace multiple calls to 
guid_equal with lookup table and one call in loop?

Do let me know if something like the following works and I will send it 
as a proper patch:

diff --git a/sound/soc/intel/avs/path.c b/sound/soc/intel/avs/path.c
index 3d46dd5e5bc4..ce157a8d6552 100644
--- a/sound/soc/intel/avs/path.c
+++ b/sound/soc/intel/avs/path.c
@@ -449,35 +449,39 @@ static int avs_modext_create(struct avs_dev *adev, 
struct avs_path_module *mod)
         return ret;
  }

+static int avs_probe_create(struct avs_dev *adev, struct 
avs_path_module *mod)
+{
+       dev_err(adev->dev, "Probe module can't be instantiated by 
topology");
+       return -EINVAL;
+}
+
+struct avs_module_create {
+       guid_t *guid;
+       int (*create)(struct avs_dev *adev, struct avs_path_module *mod);
+};
+
+static struct avs_module_create avs_module_create[] = {
+       { &AVS_MIXIN_MOD_UUID, avs_modbase_create },
+       { &AVS_MIXOUT_MOD_UUID, avs_modbase_create },
+       { &AVS_KPBUFF_MOD_UUID, avs_modbase_create },
+       { &AVS_COPIER_MOD_UUID, avs_copier_create },
+       { &AVS_MICSEL_MOD_UUID, avs_micsel_create },
+       { &AVS_MUX_MOD_UUID, avs_mux_create },
+       { &AVS_UPDWMIX_MOD_UUID, avs_updown_mix_create },
+       { &AVS_SRCINTC_MOD_UUID, avs_src_create },
+       { &AVS_AEC_MOD_UUID, avs_aec_create },
+       { &AVS_ASRC_MOD_UUID, avs_asrc_create },
+       { &AVS_INTELWOV_MOD_UUID, avs_wov_create },
+       { &AVS_PROBE_MOD_UUID, avs_probe_create },
+};
+
  static int avs_path_module_type_create(struct avs_dev *adev, struct 
avs_path_module *mod)
  {
         const guid_t *type = &mod->template->cfg_ext->type;

-       if (guid_equal(type, &AVS_MIXIN_MOD_UUID) ||
-           guid_equal(type, &AVS_MIXOUT_MOD_UUID) ||
-           guid_equal(type, &AVS_KPBUFF_MOD_UUID))
-               return avs_modbase_create(adev, mod);
-       if (guid_equal(type, &AVS_COPIER_MOD_UUID))
-               return avs_copier_create(adev, mod);
-       if (guid_equal(type, &AVS_MICSEL_MOD_UUID))
-               return avs_micsel_create(adev, mod);
-       if (guid_equal(type, &AVS_MUX_MOD_UUID))
-               return avs_mux_create(adev, mod);
-       if (guid_equal(type, &AVS_UPDWMIX_MOD_UUID))
-               return avs_updown_mix_create(adev, mod);
-       if (guid_equal(type, &AVS_SRCINTC_MOD_UUID))
-               return avs_src_create(adev, mod);
-       if (guid_equal(type, &AVS_AEC_MOD_UUID))
-               return avs_aec_create(adev, mod);
-       if (guid_equal(type, &AVS_ASRC_MOD_UUID))
-               return avs_asrc_create(adev, mod);
-       if (guid_equal(type, &AVS_INTELWOV_MOD_UUID))
-               return avs_wov_create(adev, mod);
-
-       if (guid_equal(type, &AVS_PROBE_MOD_UUID)) {
-               dev_err(adev->dev, "Probe module can't be instantiated 
by topology");
-               return -EINVAL;
-       }
+       for (int i = 0; i < ARRAY_SIZE(avs_module_create); i++)
+               if (guid_equal(type, avs_module_create[i].guid))
+                       return avs_module_create[i].create(adev, mod);

         return avs_modext_create(adev, mod);
  }
